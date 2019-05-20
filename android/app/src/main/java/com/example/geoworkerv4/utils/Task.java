package com.example.geoworkerv4.utils;

import android.content.Context;

// import com.example.geoworkerv4.classes.GeoWorker;
import com.example.geoworkerv4.classes.GeoWorkerTransport;

import java.util.HashMap;
import java.util.Map;

public class Task implements Runnable {
    private GeoWorkerTransport geoWorkerTransport;

    public Task(Context _context, String _name, String server)
    {
        this.geoWorkerTransport = new GeoWorkerTransport(_context, _name, server);
    }

    public Map<String, Object> createTaskMap() {
        Map<String, Object> result = new HashMap<String, Object>();
        boolean isReady = this.geoWorkerTransport.getIsReady();

        result.put("successfullyCompleted", !isReady ? 0 : this.geoWorkerTransport.getSuccessfullyCompleted());
        result.put("completedWithErrors", !isReady ? 0 : this.geoWorkerTransport.getCompletedWithErrors());
        result.put("notFound", !isReady ? 0 : this.geoWorkerTransport.getNotFound());
        result.put("totalSuccessfullyCompleted", !isReady ? 0 : this.geoWorkerTransport.getTotalSuccessfullyCompleted());
        result.put("totalCompletedWithErrors", !isReady ? 0 : this.geoWorkerTransport.getTotalCompletedWithErrors());
        result.put("totalNotFound", !isReady ? 0 : this.geoWorkerTransport.getTotalNotFound());
        result.put("currentDataSize", !isReady ? 0 : this.geoWorkerTransport.getCurrentDataSize());
        result.put("isConnected", this.geoWorkerTransport.getIsConnected());
        result.put("identifier", this.geoWorkerTransport.getIdentifier());
        result.put("timesCompleted", !isReady ? 0 : this.geoWorkerTransport.getTimesCompleted());
        result.put("isReady", isReady);
        return result;
    }

    public void run()
    {
        try
        {
            this.geoWorkerTransport.download();
            System.out.println(this.geoWorkerTransport.getIdentifier() + " complete");
        } catch (Exception e) {
            System.out.println(this.geoWorkerTransport.getIdentifier() + " - ERROR WHILE SPAWNING IN BACKGROUND");
            System.out.println(e.toString());
        }
    }
}
