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
      debugShowCheckedModeBanner: false,
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
    with TickerProviderStateMixin<PlatformSmiley> {
  static const platform = const MethodChannel('flutter.kpsroka.dev/sensors');

  Offset _offset = Offset.zero;
  Ticker _ticker;

  AnimationController _colorController;
  Animation<Color> _bgColorAnimation;
  Animation<Color> _fgColorAnimation;

  @override
  void initState() {
    super.initState();

    _colorController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _bgColorAnimation = _colorController
        .drive(ColorTween(begin: Colors.white, end: Colors.black));
    _fgColorAnimation = _colorController
        .drive(ColorTween(begin: Colors.black, end: Colors.white));

    platform.setMethodCallHandler((methodCall) {
      if (methodCall.method == 'onLightLevelChange') {
        setState(() {
          _colorController
              .animateTo((methodCall.arguments / 100).roundToDouble());
        });
      } else {
        throw MissingPluginException('No such method: ${methodCall.method}');
      }
    });

    _ticker = createTicker((Duration duration) {
      _refreshAccelerometer();
    });
    _ticker.start();
  }

  void dispose() {
    _colorController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _refreshAccelerometer() async {
    try {
      final List<double> result = await platform.invokeListMethod('getGravity');
      setState(() {
        _offset =
            Offset(_offset.dx - (result[0] * 5), _offset.dy + (result[1] * 5));
      });
    } on PlatformException catch (e) {
      print('Failed to get gravity reading: ${e.message}');
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
      body: Container(
        alignment: Alignment.center,
        color: _bgColorAnimation?.value,
        child: Transform.translate(
            offset: _offset,
            child: Icon(
              Icons.directions_run,
              size: 128,
              color: _fgColorAnimation?.value,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
