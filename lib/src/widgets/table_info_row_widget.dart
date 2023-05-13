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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: value
            .map<Widget>(
              (data) => Row(
                mainAxisSize: MainAxisSize.min,
                children: columns
                    .map<Widget>(
                      (currentColumn) => TableColumnInfoWidget<T>(
                        controller,
                        data: data,
                        column: currentColumn,
                        height: columnController.infoRowHeightBuilder?.call(context, data) ??
                            columnController.infoRowHeight!,
                      ),
                    )
                    .toList(growable: false),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
