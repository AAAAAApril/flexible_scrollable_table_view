import 'package:flexible_scrollable_table_view/src/scrollable/scroll_synchronization_mixin.dart';
import 'package:flutter/widgets.dart';

class HorizontalScrollControllerBuilder extends StatefulWidget {
  const HorizontalScrollControllerBuilder(
    this.mixin, {
    super.key,
    required this.builder,
  });

  final ScrollSynchronizationMixin mixin;
  final Widget Function(BuildContext context, ScrollController scrollController) builder;

  @override
  State<HorizontalScrollControllerBuilder> createState() => _HorizontalScrollControllerBuilderState();
}

class _HorizontalScrollControllerBuilderState extends State<HorizontalScrollControllerBuilder> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.mixin.createHorizontalScrollController();
  }

  @override
  void dispose() {
    widget.mixin.releaseHorizontalScrollController(scrollController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, scrollController);
  }
}
