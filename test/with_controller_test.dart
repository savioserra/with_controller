import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart' as MobX;
import 'package:flutter_test/flutter_test.dart';
import 'package:with_controller/widgets/with_controller_widget.dart';
import 'package:with_controller/with_controller.dart';

class CounterStore {
  late MobX.Observable<int> counter;
  MobX.Action? increment;

  CounterStore() {
    counter = MobX.Observable(0);
    increment = MobX.Action(() => counter.value++);
  }
}

void main() {
  group('WithController', () {
    testWidgets("calls the controller factory", (tester) async {
      var widgetKey = Key('withController');

      await tester.pumpWidget(
        WithController(
          controller: (ctx) => CounterStore(),
          builder: (ctx, dynamic ctrl) => Container(),
          key: widgetKey,
        ),
      );

      WithControllerState<CounterStore> widgetState =
          (tester.element(find.byKey(widgetKey)) as StatefulElement).state
              as WithControllerState<CounterStore>;

      expect(widgetState.controller, isNotNull);
      expect(widgetState.controller.counter.value, 0);
    });

    testWidgets("calls the builder function", (tester) async {
      var textWidgetKey = Key('text');

      await tester.pumpWidget(
        MaterialApp(
          home: WithController<CounterStore>(
            controller: (ctx) => CounterStore(),
            builder: (ctx, ctrl) => Container(
              child: Text("Counter: ${ctrl.counter.value}", key: textWidgetKey),
            ),
          ),
        ),
      );

      expect(find.text("Counter: 0"), findsOneWidget);
    });

    testWidgets("expect reactions to be working", (tester) async {
      var holder = 0;
      var buttonKey = Key("tap");

      await tester.pumpWidget(
        MaterialApp(
          home: WithController<CounterStore>(
            reactions: [
              (ctrl) => MobX.reaction(
                  (r) => ctrl.counter.value, (dynamic v) => holder = v)
            ],
            controller: (ctx) => CounterStore(),
            builder: (ctx, ctrl) => RaisedButton(
              onPressed: () => ctrl.increment!.call(),
              child: Text("Increment"),
              key: buttonKey,
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(buttonKey));
      expect(holder, 1);

      await tester.tap(find.byKey(buttonKey));
      expect(holder, 2);
    });

    testWidgets("calls the disposer function", (tester) async {
      var called = false;

      await tester.pumpWidget(
        WithController<CounterStore>(
          controller: (ctx) => CounterStore(),
          disposer: (ctrl) => called = true,
          builder: (ctx, ctrl) => Container(child: Container()),
        ),
      );

      await tester.pumpWidget(Container());

      expect(called, true);
    });
  });
}
