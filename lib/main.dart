import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sampleple/NextPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}); // Fix the constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'タイマー'), // Fix the constructor call
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key); // Fix the constructor

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _minute = 0;
  int _second = 0;
  int _millisecond = 0;
  Timer? _timer;
  bool _isRunning = false;

  @override
 void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.secondary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_formatNumber(_minute)} : ${_formatNumber(_second)} : ${_formatNumber(_millisecond)}',
              style: TextStyle(fontSize: 60),
            ),
            ElevatedButton(
              onPressed: () {
                toggleTimer();
              }, 
              child: Text(
                //?をつけるとデフォルトでNULL
                _isRunning ? 'ストップ' : 'スタート',
                style: TextStyle(
                  color: _isRunning ?  Colors.red: Colors.blue
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                resetTimer();
              }, 
              child: Text(
                'リセット',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }

  String _formatNumber(int number) {
    return NumberFormat('00').format(number);
  }

  void toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(
        const Duration(milliseconds: 10),
        (timer) {
          setState(() {
            _millisecond++;
            if (_millisecond > 100) {
              _millisecond = 0;
              _second++;
            }
            if (_second > 60) {
              _second = 0;
              _minute++;
            }
            if (_minute == 1 && _millisecond == 0) {
              _timer?.cancel();
              _isRunning = false;
            }
            if (_second == 10) {
              resetTimer();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  NextPage()),
              );
            }
          });
        },
      );
    }
    setState(() {
      //真と偽を入れ替える
      _isRunning = !_isRunning;
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      _minute = 0;
      _second = 0;
      _millisecond = 0;
      _isRunning = false;
    });
  }
}
