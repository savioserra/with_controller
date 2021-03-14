import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:with_controller/with_controller.dart';

class MyCounterStore {
  @observable
  int counter = 0;

  @action
  void increment() => counter++;
}

class MyHomePage extends StatelessWidget {
  final String title = "Awesome!";

  @override
  Widget build(BuildContext context) {
    return WithController<MyCounterStore>(
      controller: (ctx) => MyCounterStore(),
      reactions: [
        (controller) => autorun((r) => print(controller.counter)),
        (controller) =>
            when((r) => controller.counter == 10, () => print("Wow!")),
      ],
      disposer: (controller) => print("You could do something fancy here"),
      builder: (context, controller) => Column(
        children: [
          Text(title),
          ElevatedButton(
            child: Text("Click Me"),
            onPressed: controller.increment,
          )
        ],
      ),
    );
  }
}
