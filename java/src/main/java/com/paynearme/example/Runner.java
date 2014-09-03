package com.paynearme.example;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class Runner {
    public static void main(String[] args) {
        String host, secret;
        List<String> params;
        if (args.length >= 3) {
            host = args[0];
            secret = args[2];

            params = Arrays.asList(Arrays.copyOfRange(args, 3, args.length));
        } else {
            System.err.println("usage: java " + Runner.class.getSimpleName() + " <host> <secret> [param=value]");
            System.exit(1);
            return; // suppresses IDE errors...
        }

        PnmApiClient api = new PnmApiClient(host, secret);
        api.setParam("version", "2.0");
        api.setParam("timestamp", Long.toString(System.currentTimeMillis() / 1000L));

        for (String param : params) {
            String[] p = param.split("=");
            if (p.length != 2) continue;
            api.setParam(p[0], p[1]);
        }

        System.out.println("URL for request: " + api.getUrlString());

        HttpResponse response = api.execute();
        if (response != null) {
            try {
                HttpEntity entity = response.getEntity();
                entity.writeTo(System.out);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
