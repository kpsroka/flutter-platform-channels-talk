import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlatformSmiley(),
    );
  }
}

class PlatformSmiley extends StatefulWidget {
  @override
  _PlatformSmileyState createState() => _PlatformSmileyState();
}

class _PlatformSmileyState extends State<PlatformSmiley>
    with SingleTickerProviderStateMixin<PlatformSmiley> {
  static const platform = const MethodChannel('flutter.kpsroka.dev/sensors');

  Offset _offset = Offset.zero;
  Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration duration) {
      _refreshAccelerometer();
    });
    _ticker.start();
  }

  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _refreshAccelerometer() async {
    try {
      final List<double> result =
          await platform.invokeListMethod('getGravity');
      setState(() {
        _offset = Offset(
            _offset.dx - (result[0] * 5), _offset.dy + (result[1] * 5));
      });
    } on PlatformException catch (e) {
      print('Failed to get acceleration reading: ${e.message}');
    }
  }

  void _refresh() {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.translate(
            offset: _offset, child: Icon(Icons.directions_run, size: 128)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
