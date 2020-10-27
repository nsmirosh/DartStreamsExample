import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streams Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Streams Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _progress = 0;

  String streamControllerStatus = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'Stream controller status: $streamControllerStatus',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              '$_progress',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              child: Text("Start Stream"),
              onPressed: () => _startStream(),
            ),
            RaisedButton(
              child: Text("Stop Stream"),
              onPressed: () => _stopStream(),
            ),
          ],
        ),
      ),
    );
  }

  _startStream() {
    print("start stream initiated");
    /*final subscription = */timedCounter(Duration(seconds: 1)).listen((event) {
      print("event = $event");
      setState(() => _progress = event);
    });

//    subscription.cancel();
  }

  _stopStream() {}

  Stream<int> timedCounter(Duration interval, [int maxCount]) {
    StreamController<int> controller;
    Timer timer;
    int counter = 0;

    void tick(_) {
      counter++;
      controller.add(counter);
      if (counter == maxCount) {
        timer.cancel();
        controller.close();
      }
    }

    void startTimer() {
      timer = Timer.periodic(interval, tick);
    }

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }

    controller = StreamController<int>(
        onListen:()  {
          streamControllerStatus = "onListen invoked";
          startTimer();
        },
        onPause: stopTimer,
        onResume: startTimer,
        onCancel: stopTimer);

    return controller.stream;
  }
}
