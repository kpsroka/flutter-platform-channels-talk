import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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

class _PlatformSmileyState extends State<PlatformSmiley> {
  Offset _offset = Offset.zero;

  void _refresh() {
    setState(() {
      _offset = Offset(100, 100);
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
