import 'package:flutter/material.dart';
import 'package:flutter_isolate/first_isolate.dart';

import 'package:flutter_isolate/second_isolate.dart';
import 'package:flutter_isolate/third_isolate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(
        title: 'Flutter Isolate',
      ),
    );
  }
}

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  HomeStateState createState() => HomeStateState();
}

class HomeStateState extends State<Home> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    late final AnimationController animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false);

    late final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.linear,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: animation,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: const Text('Run Isolate 1'),
                onPressed: () {
                  FirstIsolate().runIsolate();
                },
              ),
              ElevatedButton(
                child: const Text('Run Isolate 2'),
                onPressed: () {
                  SecondIsolate().runIsolate();
                },
              ),
              ElevatedButton(
                child: const Text('Run Isolate 3'),
                onPressed: () {
                  ThirdIsolate().runIsolate();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
