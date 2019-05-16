package com.example.geoworkerv4;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


// import com.example.flutter_to_native.classes.GeoWorkerTransport;
import com.example.geoworkerv4.utils.Task;

import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "vida.software/geoworkerv4";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("startGeoWorker")) {
                  startGeoWorker();
                  result.success(null);
                }
              }});
  }

  private void startGeoWorker() {
    System.out.println("Iniciando el transporte");

    ArrayList<Task> tasks = new ArrayList<>();
    int TASKS_COUNT = 10;
    for (int i = 0; i < TASKS_COUNT; i++) {
      tasks.add(new Task(this.getApplicationContext(),"Transporte " + i));
    }

    ExecutorService pool = Executors.newFixedThreadPool(TASKS_COUNT);

    for (int i = 0; i < TASKS_COUNT; i++) {
      pool.execute(tasks.get(i));
    }

    pool.shutdown();
  }
}
