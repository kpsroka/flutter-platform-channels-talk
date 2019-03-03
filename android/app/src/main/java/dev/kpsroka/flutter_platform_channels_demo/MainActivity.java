package dev.kpsroka.flutter_platform_channels_demo;

import android.content.Context;
import android.os.Bundle;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
  private SensorManager sensorManager;
  private Sensor gravitySensor, lightSensor;
  private SensorHandler sensorHandler;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
    gravitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);
    lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);

    MethodChannel channel = new MethodChannel(getFlutterView(), "flutter.kpsroka.dev/sensors");
    sensorHandler = new SensorHandler(channel);
    channel.setMethodCallHandler(sensorHandler);
  }

  @Override
  protected void onResume() {
    super.onResume();
    sensorManager.registerListener(sensorHandler, gravitySensor, SensorManager.SENSOR_DELAY_UI);
    sensorManager.registerListener(sensorHandler, lightSensor, SensorManager.SENSOR_DELAY_UI);
  }

  @Override
  protected void onPause() {
    super.onPause();
    sensorManager.unregisterListener(sensorHandler);
  }
}
