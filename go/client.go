package pnmapi

import (
	"bytes"
	"crypto/hmac"
	"crypto/md5"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"sort"
	"time"
)

type Client struct {
	Version    string
	ApiKey     string
	secret     string
	baseURL    string
	SiteID     string
	HTTPClient *http.Client
}

func NewClient(siteID string, apiKey string, secret string, version string) *Client {
	return &Client{
		Version: version,
		ApiKey:  apiKey,
		SiteID:  siteID,
		secret:  secret,
		HTTPClient: &http.Client{
			Timeout: 5 * time.Minute,
		},
		baseURL: "http://dev.paynearme.com:3000/json-api",
	}
}

type PnmError struct {
	Description string `json:"description"`
}

type errorResponse struct {
	Status    string     `json:"status"`
	PnmErrors []PnmError `json:"errors"`
}

func (c *Client) signParams(params url.Values) {
	keys := make([]string, 0, len(params))
	toSign := ""

	for k := range params {
		keys = append(keys, k)
	}

	sort.Strings(keys)

	for _, k := range keys {
		toSign += k + params[k][0]
	}

	fmt.Println("Signing:", toSign)

	if c.Version == "2.0" {
		params.Add("signature", fmt.Sprintf("%x", md5.Sum([]byte(toSign+c.secret))))
	} else {
		mac := hmac.New(sha256.New, []byte(c.secret))
		mac.Write([]byte(toSign))
		params.Add("signature", hex.EncodeToString(mac.Sum(nil)))
	}
}

func (c *Client) baseParams() url.Values {
	params := url.Values{}
	params.Add("timestamp", fmt.Sprint(time.Now().Unix()))
	params.Add("version", c.Version)
	params.Add("site_identifier", "CARDAMOM")
	params.Add("api_key_id", c.ApiKey)

	return params
}

func (c *Client) buildRequest(method string, params url.Values) (http.Request, error) {
	c.signParams(params)

	url := fmt.Sprintf("%s/%s", c.baseURL, method)
	body := bytes.NewBufferString("")
	verb := "POST"

	if c.Version == "2.0" {
		verb = "GET"
		url += "?" + params.Encode()
	} else {
		body.WriteString(params.Encode())
	}

	req, err := http.NewRequest(verb, url, body)

	if err != nil {
		return *req, err
	}

	// req.Header.Set("Content-Type", "application/json; charset=utf-8")

	return *req, nil
}

// Content-type and body should be already added to req
func (c *Client) sendRequest(req *http.Request, v interface{}) error {
	req.Header.Set("Accept", "application/json; charset=utf-8")

	res, err := c.HTTPClient.Do(req)
	if err != nil {
		return err
	}

	if res.StatusCode != http.StatusOK {
		return fmt.Errorf("unknown error, status code: %d", res.StatusCode)
	}

	// Because we're going to try to process it twice, once for errors and finally for the expected results
	bodyBytes, _ := ioutil.ReadAll(res.Body)
	defer res.Body.Close()

	var errRes errorResponse
	if err = json.NewDecoder(ioutil.NopCloser(bytes.NewBuffer(bodyBytes))).Decode(&errRes); err == nil {
		if errRes.PnmErrors != nil {
			// TODO: Return all errors?
			return errors.New(errRes.PnmErrors[0].Description)
		}
	}

	// Unmarshall and populate v
	if err = json.NewDecoder(ioutil.NopCloser(bytes.NewBuffer(bodyBytes))).Decode(v); err != nil {
		return err
	}

	return nil
}
