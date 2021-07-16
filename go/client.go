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

type Response interface {
	UnmarshalBody([]byte) error
}

func GetResponse(b []byte, v Response) error {
	return v.UnmarshalBody(b)
}

type PnmError struct {
	Description string `json:"description"`
}

type errorResponse struct {
	Status    string     `json:"status"`
	PnmErrors []PnmError `json:"errors"`
}

func (res *errorResponse) UnmarshalBody(b []byte) error {
	json.Unmarshal(b, &res)

	if res.PnmErrors != nil {
		return errors.New("errors in request")
	} else {
		return nil
	}
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

	if req, err := http.NewRequest(verb, url, body); err != nil {
		return *req, err
	} else {
		return *req, nil
	}
}

// Content-type and body should be already added to req
func (c *Client) sendRequest(req *http.Request, v Response) error {
	req.Header.Set("Accept", "application/json; charset=utf-8")

	if res, err := c.HTTPClient.Do(req); err == nil {
		if res.StatusCode != http.StatusOK {
			return fmt.Errorf("unknown error, status code: %d", res.StatusCode)
		}

		bodyBytes, _ := ioutil.ReadAll(res.Body)
		defer res.Body.Close()

		var errRes errorResponse
		if err = GetResponse(bodyBytes, &errRes); err != nil {
			for _, e := range errRes.PnmErrors {
				err = fmt.Errorf("%w; %s", err, e.Description)
			}
			return err
		} else {
			return GetResponse(bodyBytes, v)
		}
	} else {
		return err
	}
}
