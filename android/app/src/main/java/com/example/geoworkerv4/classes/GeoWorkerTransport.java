package com.example.geoworkerv4.classes;

import com.squareup.okhttp.MediaType;
import android.content.Context;

import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import java.util.concurrent.TimeUnit;

public class GeoWorkerTransport {
    private String base = "http://192.168.0.175:2193";
    private String fetchUrl;
    private String pushUrl;

    private GeoWorker geoWorker;
    private int timesCompleted;
    private String identifier;

    private Context context;

    private boolean isConnected;
    private int currentDataSize;

    private int totalSuccessfullyCompleted;
    private int totalCompletedWithErrors;
    private int totalNotFound;

    private boolean isReady;

    public GeoWorkerTransport (Context _context, String _identifier) {
        this.context = _context;

        this.fetchUrl = this.base + "/fetch";
        this.pushUrl = this.base + "/push";
        this.timesCompleted = 0;
        this.identifier = _identifier;

        this.isReady = false;

        // this.download();
    }

    public int getSuccessfullyCompleted () {
        return geoWorker.getSuccessfullyCompleted();
    }

    public int getCompletedWithErrors() {
        return geoWorker.getCompletedWithErrors();
    }

    public int getNotFound() {
        return geoWorker.getNotFound();
    }

    public int getTotalSuccessfullyCompleted () {
        return totalSuccessfullyCompleted;
    }

    public int getTotalCompletedWithErrors() {
        return totalCompletedWithErrors;
    }

    public int getTotalNotFound() {
        return totalNotFound;
    }

    public int getCurrentDataSize() {
        return currentDataSize;
    }

    public boolean getIsConnected() {
        return isConnected;
    }

    public String getIdentifier() {
        return identifier;
    }

    public int getTimesCompleted() {
        return timesCompleted;
    }

    public boolean getIsReady() {
        return isReady;
    }

    public void download () {
        OkHttpClient client = new OkHttpClient();
        client.setConnectTimeout(1000 * 30, TimeUnit.MILLISECONDS);
        Request request = new Request.Builder()
                .url(this.fetchUrl)
                .get()
                .build();
        try {
            Response response = client.newCall(request).execute();
            geoWorker = new GeoWorker(this.context, response.body().string(), this.identifier);
            this.isReady = true;

            this.isConnected = geoWorker.importedAddresses.getConnected();
            this.currentDataSize = geoWorker.importedAddresses.getItems().size();
            System.out.println(this.identifier + " - Is connected: " + this.isConnected);
            System.out.println(this.identifier + " - items length: " + this.currentDataSize);

            if (this.currentDataSize == 0) {
                if (this.isConnected){
                    System.out.println(this.identifier + " - Reload App");
                    Thread.sleep(1000 * 1);
                    this.download();
                }
                else return;
            } else {
                System.out.println(this.identifier + " - MULTI CODE");
                // Add to totalSuccessfullyCompleted
                // Add to total
                String multiGeocodeData = geoWorker.multiGeocode();
                totalSuccessfullyCompleted += geoWorker.getSuccessfullyCompleted();
                totalCompletedWithErrors += geoWorker.getCompletedWithErrors();
                totalNotFound += geoWorker.getNotFound();

                this.upload(multiGeocodeData);
                // geoWorker.multiGeocode().then((data) => this.upload(data));
            }

        } catch (Exception ex) {
            System.out.println(this.identifier + " - ERROR DOWNLOADING");
            System.out.println(ex.toString());
        }

    }

    private void upload (String data) {
        OkHttpClient client = new OkHttpClient();
        client.setConnectTimeout(1000 * 30, TimeUnit.MILLISECONDS);
        client.setWriteTimeout(1000 * 30, TimeUnit.MILLISECONDS);
        client.setReadTimeout(1000 * 30, TimeUnit.MILLISECONDS);

        MediaType mediaType = MediaType.parse("application/json");
        RequestBody body = RequestBody.create(mediaType, data);
        Request request = new Request.Builder()
                .url(this.pushUrl)
                .header("Content-Type", "application/json")
                .post(body)
                .build();


        try {
            Response response = client.newCall(request).execute();
            System.out.println(this.identifier + " - SEND");
            System.out.println(this.identifier + " - Response status: " + response.code());
            System.out.println(this.identifier + " - Response body: " + response.body());
            this.timesCompleted++;
            this.download();
        } catch (Exception ex) {
            System.out.println(this.identifier + " - ERROR UPLOADING");
            System.out.println(ex.toString());
        }

    }
}
