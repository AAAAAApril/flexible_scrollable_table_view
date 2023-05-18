import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_header_widget.dart';
import 'package:flutter/widgets.dart';

///表头行
class FlexibleTableHeaderRow<T> extends StatelessWidget {
  const FlexibleTableHeaderRow(
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
    Widget child;
    if (configurations.pinnedColumns.isNotEmpty && configurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        PinnedTableHeaderRow<T>(
          controller,
          configurations: configurations,
        ),
        Expanded(
          child: ScrollableTableHeaderRow<T>(
            controller,
            configurations: configurations,
            physics: physics,
          ),
        ),
      ]);
    } else {
      if (configurations.pinnedColumns.isEmpty) {
        child = ScrollableTableHeaderRow<T>(
          controller,
          configurations: configurations,
          physics: physics,
        );
      } else {
        child = PinnedTableHeaderRow<T>(
          controller,
          configurations: configurations,
        );
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
        child: ListView.builder(
          controller: controller.headerRowScrollController,
          itemCount: configurations.scrollableColumnList.length,
          scrollDirection: Axis.horizontal,
          primary: false,
          padding: EdgeInsets.zero,
          physics: physics,
          itemBuilder: (context, index) => TableColumnHeaderWidget<T>(
            controller,
            column: configurations.scrollableColumnList[index],
            height: configurations.headerRowHeight,
          ),
        ),
      ),
    );
  }
}
