import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
final class SelectableColumn<T> extends AbsFlexibleColumn<T> {
  SelectableColumn({
    required this.selectableColumn,
    required this.unSelectableColumn,
  }) : super('${selectableColumn.id}_${unSelectableColumn.id}');

  final AbsFlexibleColumn<T> selectableColumn;
  final AbsFlexibleColumn<T> unSelectableColumn;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return selectableColumn.buildHeaderCell(arguments);
        }
        return unSelectableColumn.buildHeaderCell(arguments);
      },
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return selectableColumn.buildInfoCell(arguments);
        }
        return unSelectableColumn.buildInfoCell(arguments);
      },
    );
  }
}
