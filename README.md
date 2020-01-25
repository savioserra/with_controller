# with_controller

A `WithController` widget is a convenience widget for reducing [MobX](https://mobx.pub/) boilerplate burden when you need to initialize a store (and dispose it) and create reactions (and dispose them).

## Getting Started

### Instalation

1. Add `with_controller` to your `pubspec.yaml`
2. Run `flutter pub get` in your terminal
3. That's it!

### Example

```dart
  class MyCounterStore {
    @observable
    counter = 0;

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
          (controller) => when((r) => controller.counter == 10, () => print("Wow!")),
        ],
        disposer: (controller) => print("You could do something fancy here"),
        builder: (context, controller) => Column(
          children: [
            Text(title),
            RaisedButton(
              child: Text("Click Me"),
              onTap: controller.increment,
            )
          ],
        ),
      );
    }
  }
```
