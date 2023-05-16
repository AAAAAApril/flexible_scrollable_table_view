import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/scroll_behavior.dart';
import 'package:flutter/widgets.dart';

import 'table_view_info_row.dart';

///表内容区域
class TableViewContentArea<T> extends StatelessWidget {
  const TableViewContentArea(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    this.scrollController,
    this.shrinkWrap = false,
    this.primary,
    this.physics,
    this.disableVerticalScroll = false,
    this.footer,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final ScrollController? scrollController;
  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool disableVerticalScroll;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    double? itemExtent;
    if (columnConfigurations.infoRowHeightBuilder == null) {
      itemExtent = columnConfigurations.infoRowHeight;
    }
    Widget child = ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => ListView.builder(
        controller: scrollController,
        itemCount: value.length + (footer != null ? 1 : 0),
        shrinkWrap: shrinkWrap,
        primary: primary,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemExtent: itemExtent,
        physics: physics,
        itemBuilder: (context, index) {
          if (index == value.length) {
            return footer;
          }
          return TableViewInfoRow<T>(
            controller,
            columnConfigurations: columnConfigurations,
            dataIndex: index,
            data: value[index],
          );
        },
      ),
    );
    if (controller.noVerticalScrollBehavior) {
      child = ScrollConfiguration(
        behavior: const NoOverscrollScrollBehavior(),
        child: child,
      );
    }
    if (disableVerticalScroll) {
      return child;
    }
    return LayoutBuilder(
      builder: (p0, p1) => SizedBox.fromSize(
        size: Size(p1.maxWidth, p1.maxHeight),
        child: child,
      ),
    );
  }
}
