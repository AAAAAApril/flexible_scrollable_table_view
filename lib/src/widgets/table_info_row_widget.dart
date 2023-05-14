import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行组件
class TableInfoRowWidget<T> extends StatelessWidget {
  const TableInfoRowWidget(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    required this.columns,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final Set<FlexibleColumn<T>> columns;

  Widget createRow(BuildContext context, int index, T data) {
    final double fixedHeight = columnConfigurations.fixedInfoRowHeight(context, data);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (currentColumn) => TableColumnInfoWidget<T>(
              controller,
              dataIndex: index,
              data: data,
              column: currentColumn,
              height: fixedHeight,
            ),
          )
          .toList(growable: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => Column(mainAxisSize: MainAxisSize.min, children: [
        for (int index = 0; index < value.length; index++) createRow(context, index, value[index]),
      ]),
    );
    if (columns.containsSelectableColumns) {
      child = ValueListenableBuilder<bool>(
        valueListenable: controller.selectable,
        builder: (context, selectable, child) => SizedBox(
          width: columnConfigurations.computeColumnsWith(columns, selectable),
          child: child,
        ),
        child: child,
      );
    } else {
      child = SizedBox(
        width: columnConfigurations.computeColumnsWith(columns, false),
        child: child,
      );
    }
    return child;
  }
}
