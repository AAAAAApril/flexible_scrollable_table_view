import 'package:flexible_scrollable_table_view/src/custom/selectable/selectable_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行组件
class TableInfoRowWidget<T> extends StatelessWidget {
  const TableInfoRowWidget(
    this.controller, {
    super.key,
    required this.columnController,
    required this.columns,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnController<T> columnController;
  final Set<FlexibleColumn<T>> columns;

  Widget createRow(BuildContext context, int index, T data) {
    final double fixedHeight =
        columnController.infoRowHeightBuilder?.call(context, data) ?? columnController.infoRowHeight!;
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
    return ValueListenableBuilder<bool>(
      valueListenable: controller.selectable,
      builder: (context, selectable, child) => SizedBox(
        width: columns.fold<double>(0, (previousValue, element) {
          double currentWidth = element.fixedWidth;
          if (element is SelectableColumn<T>) {
            currentWidth = selectable ? element.fixedWidth : element.unSelectableWidth;
          }
          return previousValue + currentWidth;
        }),
        child: child,
      ),
      child: ValueListenableBuilder<List<T>>(
        valueListenable: controller,
        builder: (context, value, child) => Column(mainAxisSize: MainAxisSize.min, children: [
          for (int index = 0; index < value.length; index++) createRow(context, index, value[index]),
        ]),
      ),
    );
  }
}
