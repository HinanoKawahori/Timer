import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  //アプリが起動されるとrunAppが走る。
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'タイマー',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title; //変数をMyAppからもらう。

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  //statefulwidgetは、状態をもつwidgetなので、createStateがある。
}

class _MyHomePageState extends State<MyHomePage> {
  int _minute = 0;
  int _second = 0;
  double _millisecond = 0;

  Timer? _minuteTimer;
  Timer? _secondTimer;
  Timer? _milliSecondTimer;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();

//millisecondTimer
    _milliSecondTimer =
        Timer.periodic(const Duration(milliseconds: 10), (milliSecondimer) {
      setState(() {
        _millisecond++;
        if (_millisecond == 60) {
          _millisecond = 0;
          _second++;
        }
        if (_second == 60) {
          _second = 0;
          _minute++;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //タイマー表記

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$_minute', style: const TextStyle(fontSize: 64)),
              const Text('.', style: TextStyle(fontSize: 64)),
              Text('$_second', style: const TextStyle(fontSize: 64)),
              const Text('.', style: TextStyle(fontSize: 64)),
              Text('$_millisecond', style: const TextStyle(fontSize: 64)),
            ],
          ),

          //toggledボタン   gっh
          ElevatedButton(
            onPressed: () {
              toggleTimer();
            },
            child: Text(
              _isRunning ? 'ストップ' : 'スタート',
              style: TextStyle(
                color: _isRunning ? Colors.blue : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
          //リセットボタン
          ElevatedButton(
              onPressed: () {
                resetTimer();
              },
              child: const Text('リセット'))
        ],
      )),
    );
  }

  //stop関数
  void toggleTimer() {
    if (_isRunning) {
      _milliSecondTimer?.cancel();
      //状態を再通知するのを忘れずに！
      setState(() {
        _isRunning = false;
      });
    } else {
      _milliSecondTimer =
          Timer.periodic(const Duration(milliseconds: 10), (milliSecondimer) {
        setState(() {
          _millisecond++;
          if (_millisecond == 60) {
            _millisecond = 0;
            _second++;
          }
          if (_second == 60) {
            _second = 0;
            _minute++;
          }
        });
      });
      //状態を再通知するのを忘れずに！
      setState(() {
        _isRunning = true;
      });
    }
  }

  //reset関数
  void resetTimer() {
    _milliSecondTimer?.cancel();
    setState(() {
      _second = 0;
      _minute = 0;
      _millisecond = 0;
      _isRunning = false;
    });
  }
}
