package com.paynearme.example;

import com.google.common.base.Function;
import com.google.common.collect.Collections2;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.HttpClients;

import java.io.IOException;
import java.net.URI;
import java.util.*;

/* Example paynearme http request */
public class PnmApiClient {
    private HttpClient client;
    private String host;
    private String method;
    private String secret;

    private Map<String, String> params;

    public PnmApiClient(String host, String method, String secret) {
        client = HttpClients.createDefault();
        this.host = host;
        this.method = method;
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

    public String getUrlString() {
        return String.format("%s/%s?%s", host, method, queryString());
    }

    private String queryString() {
        final Map<String, String> signed = signedParameters();
        List<String> pairs = new ArrayList<>(Collections2.transform(signed.keySet(), new Function<String, String>() {
            @Override
            public String apply(String input) {
                return input + "=" + signed.get(input);
            }
        }));
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
