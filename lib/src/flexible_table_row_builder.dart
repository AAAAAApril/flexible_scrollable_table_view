import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_column.dart';
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
  Set<AbsFlexibleColumn<T>> get allTableColumns;

  ///构建列头项
  @protected
  Widget buildColumnHeaderCell(AbsFlexibleColumn<T> column, TableHeaderRowBuildArguments<T> arguments) {
    return column.buildHeaderCell(arguments);
  }

  ///构建列信息项
  @protected
  Widget buildColumnInfoCell(AbsFlexibleColumn<T> column, TableInfoRowBuildArguments<T> arguments) {
    return column.buildInfoCell(arguments);
  }

  ///根据列ID查找列配置类
  AbsFlexibleColumn<T>? findColumnById(String columnId) {
    try {
      return allTableColumns.firstWhere((element) => element.id == columnId);
    } catch (_) {
      return null;
    }
  }

  ///根据列ID查找可排序列配置类
  SortableColumnMixin<T>? findSortableColumnById(String columnId) {
    return findColumnById(columnId) as SortableColumnMixin<T>?;
  }
}
