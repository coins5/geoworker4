package com.example.geoworkerv4.utils;

import android.content.Context;

import com.example.geoworkerv4.classes.GeoWorkerTransport;

public class Task implements Runnable {
    private String name;
    Context context;
    public Task(Context _context, String _name)
    {
        this.name = _name;
        this.context = _context;
    }

    public void run()
    {
        try
        {
            new GeoWorkerTransport(this.context, this.name);
            System.out.println(name+" complete");
        } catch (Exception e) {
            System.out.println(this.name + " - ERROR WHILE SPAWNING IN BACKGROUND");
            System.out.println(e.toString());
        }
    }
}
