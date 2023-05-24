import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

class HorizontalScrollControllerBuilder<T> extends StatefulWidget {
  const HorizontalScrollControllerBuilder(
    this.controller, {
    super.key,
    required this.builder,
  });

  final FlexibleTableController<T> controller;
  final Widget Function(BuildContext context, ScrollController scrollController) builder;

  @override
  State<HorizontalScrollControllerBuilder<T>> createState() => _HorizontalScrollControllerBuilderState<T>();
}

class _HorizontalScrollControllerBuilderState<T> extends State<HorizontalScrollControllerBuilder<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller.createHorizontalScrollController();
  }

  @override
  void dispose() {
    widget.controller.releaseHorizontalScrollController(scrollController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, scrollController);
  }
}
