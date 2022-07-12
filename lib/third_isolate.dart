import 'dart:isolate';

import 'package:flutter/foundation.dart';

import 'isolate_object.dart';

class ThirdIsolate {
  Isolate? _isolate1;
  Isolate? _isolate2;

  void runIsolate() async {
    debugPrint('Start Method');

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

    runWhile("Main isolate");
  }

  void isolate1Runner(IsolateObject isolateObject) {
    var message = IsolateObject(
      value: '${isolateObject.value} - ${DateTime.now()}',
      sender: isolateObject.sender,
    );

    debugPrint('Started running - Method 1');

    runWhile("Isolate 1");

    isolateObject.sender.send(message);
  }

  void isolate2Runner(SendPort sendPort) {
    var message = 'From Isolate 2';

    debugPrint('Started running - Method 2');

    runWhile("Isolate 2");

    sendPort.send(message);
  }

  static void runWhile(String message) {
    int count = 0;
    while (count <= 500) {
      debugPrint('$message - $count');
      count++;
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
