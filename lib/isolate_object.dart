import 'dart:isolate';

class IsolateObject<T> {
  final T? value;
  final SendPort sender;

  IsolateObject({
    this.value,
    required this.sender,
  });
}
