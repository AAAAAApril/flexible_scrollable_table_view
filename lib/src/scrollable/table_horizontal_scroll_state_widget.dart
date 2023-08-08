import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flutter/widgets.dart';

class TableHorizontalScrollStateWidget extends StatefulWidget {
  const TableHorizontalScrollStateWidget(
    this.scrollMixin, {
    super.key,
    required this.builder,
  });

  final TableHorizontalScrollMixin scrollMixin;
  final Widget Function(BuildContext context, ScrollController scrollController) builder;

  @override
  State<TableHorizontalScrollStateWidget> createState() => _TableHorizontalScrollStateWidgetState();
}

class _TableHorizontalScrollStateWidgetState extends State<TableHorizontalScrollStateWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollMixin.createScrollController();
  }

  @override
  void didUpdateWidget(covariant TableHorizontalScrollStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollMixin != oldWidget.scrollMixin) {
      oldWidget.scrollMixin.destroyScrollController(scrollController);
      scrollController = widget.scrollMixin.createScrollController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.scrollMixin.destroyScrollController(scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, scrollController);
  }
}
