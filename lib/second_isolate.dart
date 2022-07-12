import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'isolate_object.dart';

class SecondIsolate {
  Isolate? _isolate1;
  Isolate? _isolate2;

  void runIsolate() async {
    stop();
    ReceivePort receivePort = ReceivePort(); //main receive port

    var message = IsolateObject(
      value: "From isolate 1",
      sender: receivePort.sendPort,
    );

    _isolate1 = await Isolate.spawn(isolate1Runner, message);
    _isolate2 = await Isolate.spawn(isolate2Runner, receivePort.sendPort);

    receivePort.listen(
      (data) {
        if (data == null) {
          debugPrint('Data not received!');
          stop();
        } else if (data.runtimeType == String) {
          debugPrint(data);
        } else if (data.runtimeType.toString() == 'IsolateObject<String>') {
          debugPrint((data as IsolateObject).value);
        }
      },
    );

    await runWhile(
      message: 'Running on the main app Isolate',
      url: 'https://jsonplaceholder.typicode.com/photos',
      turns: 2,
    );
  }

  void isolate1Runner(IsolateObject isolateObject) async {
    var message = IsolateObject(
      value: '${isolateObject.value} - ${DateTime.now()}',
      sender: isolateObject.sender,
    );

    debugPrint('Started running - Method 1');

    await runWhile(
      message: 'Running on the Isolate 1',
      url: 'https://jsonplaceholder.typicode.com/todos',
      turns: 2,
    );

    isolateObject.sender.send(message);
  }

  void isolate2Runner(SendPort sendPort) async {
    var message = 'From Isolate 2';

    debugPrint('Started running - Method 2');

    await runWhile(
      message: 'Running on the Isolate 2',
      url: 'https://jsonplaceholder.typicode.com/comments',
      turns: 2,
    );

    sendPort.send(message);
  }

  static Future<void> runWhile({
    required String message,
    required String url,
    required int turns,
  }) async {
    int count = 1;
    Response response;
    while (count <= turns) {
      if (message == 'Running on the main app Isolate') {
        await Future.delayed(const Duration(milliseconds: 300));
      } else if (message == "Running on the Isolate 1") {
        await Future.delayed(const Duration(milliseconds: 300));
      } else if (message == "Running on the Isolate 2") {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      response = await Dio().get('$url/$count');

      count++;
      debugPrint('\n$message\n${response.data.toString()}\n*** *** *** ***\n');
    }
  }

  void stop() {
    if (_isolate1 != null) {
      _isolate1!.kill(priority: Isolate.immediate);
      _isolate1 = null;
    }

    if (_isolate2 != null) {
      _isolate2!.kill(priority: Isolate.immediate);
      _isolate2 = null;
    }
  }
}
