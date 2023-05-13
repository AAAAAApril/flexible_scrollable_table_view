import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行组件
class TableInfoRowWidget<T> extends StatelessWidget {
  const TableInfoRowWidget(
    this.controller, {
    Key? key,
    required this.columnController,
    required this.columns,
  })  : assert(columns.length > 0, 'At least one scrollable column is needed.'),
        super(key: key);

  final FlexibleTableController<T> controller;
  final FlexibleColumnController<T> columnController;
  final Set<FlexibleColumn<T>> columns;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (currentColumn) => ValueListenableBuilder<List<T>>(
              valueListenable: controller,
              builder: (context, value, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: value
                    .map<Widget>(
                      (data) => TableColumnInfoWidget<T>(
                        controller,
                        data: data,
                        column: currentColumn,
                        height: columnController.infoRowHeightBuilder?.call(context, data) ??
                            columnController.infoRowHeight!,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
