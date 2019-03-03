package dev.kpsroka.flutter_platform_channels_demo;

import java.util.Arrays;

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class SensorHandler implements MethodChannel.MethodCallHandler, SensorEventListener {
  double[] lastEventValues = new double[3];

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("getGravity")) {
      result.success(lastEventValues);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }

  @Override
  public void onSensorChanged(SensorEvent event) {
    lastEventValues[0] = event.values[0];
    lastEventValues[1] = event.values[1];
    lastEventValues[2] = event.values[2];
  }
}
