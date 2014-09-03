package com.paynearme.example;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;
import java.net.URLEncoder;
/* Example paynearme http request */
public class PnmApiClient {
    private HttpClient client;
    private String host;
    private String secret;

    private Map<String, String> params;

    public PnmApiClient(String host, String secret) {
        client = HttpClients.createDefault();
        this.host = host;
        this.secret = secret;
        params = new HashMap<String, String>();
    }

    public HttpResponse execute() {
        String url = getUrlString();
        HttpUriRequest request = new HttpGet(url);
        HttpResponse response = null;
        try {
            response = client.execute(request);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return response;
    }

    public void setParam(String param, String value) {
        params.put(param, value);
    }

    @SuppressWarnings("deprecation")
    public String getUrlString() {
        try
        {

            return String.format("%s/%s?%s", host, queryString());
        }catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }

    private String queryString() throws UnsupportedEncodingException{
        final Map<String, String> signed = signedParameters();
        List<String> pairs = new ArrayList<String>(signed.keySet().size());
        for (String key : signed.keySet()) {
            pairs.add(key + "=" + URLEncoder.encode(signed.get(key),"UTF-8"));
        }
        return StringUtils.join(pairs, "&");
    }

    private static final List<String> IGNORE_PARAMS = Arrays.asList("signature");

    /**
     * Return a Map of all parameters as well as a signature for the items.
     */
    public Map<String, String> signedParameters() {
        params.remove("signature"); // if set

        // Get the keySet, sort it.
        List<String> keys = new ArrayList<String>(params.keySet());
        Collections.sort(keys);

        StringBuilder string = new StringBuilder();
        for (String key : keys) {
            if (!IGNORE_PARAMS.contains(key)) {
                string.append(key).append(params.get(key));
            }
        }
        string.append(secret);
        String signature = DigestUtils.md5Hex(string.toString());

        Map<String, String> copy = new HashMap<String, String>(params);
        copy.put("signature", signature);
        return copy;
    }
}
