package com.paynearme.example;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;

import java.io.IOException;

/**
 * Created by ryan on 4/10/14.
 */
public class Runner {
    public static void main(String[] args) {
        PnmApiClient api = new PnmApiClient("http://pnm-dev.grio.com:8080/rails40", "create_order", "secrets");
        api.setParam("version", "2.0");
        api.setParam("timestamp", Long.toString(System.currentTimeMillis() / 1000L));
        api.setParam("site_identifier", "CUTEPUPPIES");

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
