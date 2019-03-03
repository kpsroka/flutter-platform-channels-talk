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
  private Sensor gravitySensor;
  private final SensorHandler sensorHandler = new SensorHandler();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
    gravitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);

    MethodChannel channel = new MethodChannel(getFlutterView(), "flutter.kpsroka.dev/sensors");
    channel.setMethodCallHandler(sensorHandler);
  }

  @Override
  protected void onResume() {
    super.onResume();
    sensorManager.registerListener(sensorHandler, gravitySensor, SensorManager.SENSOR_DELAY_NORMAL);
  }

  @Override
  protected void onPause() {
    super.onPause();
    sensorManager.unregisterListener(sensorHandler);
  }
}
