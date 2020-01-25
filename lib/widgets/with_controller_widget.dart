import 'package:mobx/mobx.dart';
import 'package:flutter/widgets.dart';
import 'package:with_controller/typedefs.dart';

/// A [WithController] widget is a convenience widget. It avoids the need of managing a controller's lifecycle,
/// its dispose and also its reactions, since most of the times it's just boilerplate burden.
class WithController<C> extends StatefulWidget {
  /// List of reaction creators.
  /// You can use any type of reaction you want to: `when`, `autorun`, `reaction` and so on.
  ///
  /// ```dart
  /// reactions: [
  ///   (controller) => autorun((r) => print(controller.someValue)),
  ///   (controller) => autorun((r) => print(controller.someotherValue)),
  /// ]
  /// ```
  final List<ReactionCreator<C>> reactions;

  /// Controller creator. This instance is used in every callback that takes a controller, such as [disposer].
  /// It takes a [BuildContext] as argument in case you need it.
  final ControllerCreator<C> controller;

  /// Disposer function of the controller.
  ///
  /// ```dart
  /// (controller) => controller.disposeSomething();
  /// ```
  final ControllerDisposer<C> disposer;

  /// Builder function. Takes a [BuildContext] and a controller;
  final WidgetControllerBuilder<C> builder;

  const WithController({
    @required this.controller,
    @required this.builder,
    this.reactions = const [],
    this.disposer,
    Key key,
  }) : super(key: key);

  @override
  WithControllerState<C> createState() => WithControllerState();
}

@visibleForTesting
class WithControllerState<C> extends State<WithController<C>> {
  List<ReactionDisposer> reactionDisposers;
  C controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    reactionDisposers.forEach((disposer) => disposer());

    if (widget.disposer != null) widget.disposer(controller);

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (controller == null) {
      controller = widget.controller(context);
    }

    if (reactionDisposers == null) {
      reactionDisposers =
          widget.reactions.map((creator) => creator(controller)).toList();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controller);
}
