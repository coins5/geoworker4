package com.example.geoworkerv4.utils;

import android.content.Context;

// import com.example.geoworkerv4.classes.GeoWorker;
import com.example.geoworkerv4.classes.GeoWorkerTransport;

import java.util.HashMap;
import java.util.Map;

public class Task implements Runnable {
    private GeoWorkerTransport geoWorkerTransport;

    public Task(Context _context, String _name)
    {
        this.geoWorkerTransport = new GeoWorkerTransport(_context, _name);
    }

    public Map<String, Object> createTaskMap() {
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("successfullyCompleted", this.geoWorkerTransport.getSuccessfullyCompleted());
        result.put("completedWithErrors", this.geoWorkerTransport.getCompletedWithErrors());
        result.put("totalSuccessfullyCompleted", this.geoWorkerTransport.getTotalSuccessfullyCompleted());
        result.put("totalCompletedWithErrors", this.geoWorkerTransport.getTotalCompletedWithErrors());
        result.put("currentDataSize", this.geoWorkerTransport.getCurrentDataSize());
        result.put("isConnected", this.geoWorkerTransport.getIsConnected());
        result.put("identifier", this.geoWorkerTransport.getIdentifier());
        result.put("timesCompleted", this.geoWorkerTransport.getTimesCompleted());

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
