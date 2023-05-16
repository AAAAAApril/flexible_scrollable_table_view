import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/scroll_behavior.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_header_widget.dart';
import 'package:flutter/widgets.dart';

///表头行
class TableViewHeaderRow<T> extends StatelessWidget {
  const TableViewHeaderRow(
    this.controller, {
    super.key,
    required this.columnConfigurations,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (columnConfigurations.pinnedColumns.isNotEmpty && columnConfigurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        PinnedTableHeaderRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
        ),
        Expanded(
          child: ScrollableTableHeaderRow<T>(
            controller,
            columnConfigurations: columnConfigurations,
          ),
        ),
      ]);
    } else {
      if (columnConfigurations.pinnedColumns.isEmpty) {
        child = ScrollableTableHeaderRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
        );
      } else {
        child = PinnedTableHeaderRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
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
    required this.columnConfigurations,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columnConfigurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnHeaderWidget<T>(
              controller,
              column: e,
              height: columnConfigurations.headerRowHeight,
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
    required this.columnConfigurations,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        final List<FlexibleColumn<T>> columns = columnConfigurations.scrollableColumns.toList();
        Widget child = ListView.builder(
          controller: controller.headerRowScrollController,
          itemCount: columns.length,
          scrollDirection: Axis.horizontal,
          primary: false,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => TableColumnHeaderWidget<T>(
            controller,
            column: columns[index],
            height: columnConfigurations.headerRowHeight,
          ),
        );
        if (controller.noHorizontalScrollBehavior) {
          child = ScrollConfiguration(
            behavior: const NoOverscrollScrollBehavior(),
            child: child,
          );
        }
        return SizedBox.fromSize(
          size: Size(p1.maxWidth, columnConfigurations.headerRowHeight),
          child: child,
        );
      },
    );
  }
}
