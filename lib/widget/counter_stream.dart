import 'dart:async';
import 'package:practica/widget/tarea.dart';

class CounterStream {
  final _controller = StreamController<List<Tarea>>();

  Stream<List<Tarea>> get counterStream => _controller.stream;

  void startCounter(List<Tarea> tasks) {
    _controller.sink.add(tasks);
  }

  void dispose() {
    _controller.close();
  }
}
