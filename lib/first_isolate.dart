import 'dart:isolate';

import 'package:flutter/foundation.dart';

class FirstIsolate {
  Isolate? _isolate;

  void runIsolate() async {
    stop();

    ReceivePort receivePort = ReceivePort();

    _isolate = await Isolate.spawn(taskRunner, receivePort.sendPort);

    receivePort.listen((data) {
      if (data == null) {
        debugPrint('Data not received!');
      } else {
        debugPrint('${data[0]}, ${data[1]}');
      }
    });
  }

  void taskRunner(SendPort sendPort) {
    var number = 0;
    for (var i = 0; i < 1000000000; i++) {
      number += i;
    }
    var message = 'Message from first isolate';

    sendPort.send([message, number]);
  }

  void stop() {
    if (_isolate != null) {
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}
