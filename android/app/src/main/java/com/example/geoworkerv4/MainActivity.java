package com.example.geoworkerv4;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


// import com.example.flutter_to_native.classes.GeoWorkerTransport;
import com.example.geoworkerv4.utils.Task;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "vida.software/geoworkerv4";
  private ArrayList<Task> tasks;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("startGeoWorker")) {
                  int threads = call.argument("threads");
                  startGeoWorker(threads);
                  result.success(null);
                }

                if (call.method.equals("getStats")) {
                  result.success(createTasksMapList());
                }
              }});
  }

  private void startGeoWorker(int threads) {
    System.out.println("Iniciando el transporte");

    tasks = new ArrayList<>();
    for (int i = 0; i < threads; i++) {
      tasks.add(new Task(this.getApplicationContext(),"Transporte " + i));
    }

    ExecutorService pool = Executors.newFixedThreadPool(threads);

    for (int i = 0; i < threads; i++) {
      pool.execute(tasks.get(i));
    }

    pool.shutdown();
  }

  public List<Map<String, Object>> createTasksMapList() {

    List<Map<String, Object>> result = new ArrayList<Map<String, Object>>(this.tasks.size());
    for (Task task : this.tasks) {
      result.add(task.createTaskMap());
    }
    return result;
  }
}
