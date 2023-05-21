import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_scrollable_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_header_widget.dart';
import 'package:flutter/widgets.dart';

///表头（行）
class FlexibleTableHeader<T> extends StatelessWidget {
  const FlexibleTableHeader(
    this.controller, {
    super.key,
    required this.configurations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableHeaderRow<T>(
      controller,
      configurations: configurations,
    );
    final Widget scrollable = ScrollableTableHeaderRow<T>(
      controller,
      configurations: configurations,
      physics: physics,
    );
    final Widget child;
    if (configurations.pinnedColumns.isNotEmpty && configurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        pinned,
        Expanded(child: scrollable),
      ]);
    } else {
      if (configurations.scrollableColumns.isEmpty) {
        child = pinned;
      } else {
        child = scrollable;
      }
    }
    return child;
  }
}

///表头行固定区域
class PinnedTableHeaderRow<T> extends StatelessWidget {
  const PinnedTableHeaderRow(
    this.controller, {
    super.key,
    required this.configurations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnHeaderWidget<T>(
              controller,
              column: e,
              height: configurations.headerRowHeight,
            ),
          )
          .toList(growable: false),
    );
  }
}

///表头行滚动区域
class ScrollableTableHeaderRow<T> extends StatelessWidget {
  const ScrollableTableHeaderRow(
    this.controller, {
    super.key,
    required this.configurations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) => SizedBox.fromSize(
        size: Size(p1.maxWidth, configurations.headerRowHeight),
        child: TableHeaderScrollWrapper<T>(
          controller,
          columns: configurations.scrollableColumns.toList(growable: false),
          height: configurations.headerRowHeight,
          physics: physics,
        ),
      ),
    );
  }
}
