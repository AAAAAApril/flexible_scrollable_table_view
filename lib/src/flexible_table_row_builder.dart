import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_table_column.dart';
import 'package:flutter/widgets.dart';

///表行构建类
mixin FlexibleTableRowBuilderMixin<T> {
  ///构建表头行
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments);

  ///构建表信息行
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments);
}

mixin FlexibleTableRowBuilder<T> implements FlexibleTableRowBuilderMixin<T> {
  ///表内的全部列
  Set<AbsFlexibleTableColumn<T>> get allTableColumns;

  @protected
  Widget buildTableRow(Widget Function(AbsFlexibleTableColumn<T> column) buildCell);

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return buildTableRow((column) => column.buildHeaderCell(arguments));
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return buildTableRow((column) => column.buildInfoCell(arguments));
  }

  ///根据列ID查找列配置类
  AbsFlexibleTableColumn<T>? findColumnById(String columnId) {
    for (var column in allTableColumns) {
      var result = column.findColumnById(columnId);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  ///根据列ID查找可排序列配置类
  SortableTableColumnMixin<T>? findSortableColumnById(String columnId) {
    return findColumnById(columnId) as SortableTableColumnMixin<T>?;
  }
}
