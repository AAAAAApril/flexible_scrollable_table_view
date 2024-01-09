import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_table_column.dart';
import 'package:flutter/widgets.dart';

import 'arguments/table_build_arguments.dart';

///表行构建类
mixin FlexibleTableRowBuilderMixin<T>
    implements FlexibleTableHeaderRowBuilderMixin<T>, FlexibleTableInfoRowBuilderMixin<T> {}

///构建表头行
mixin FlexibleTableHeaderRowBuilderMixin<T> {
  Widget buildHeaderRow(TableBuildArgumentsMixin<T> arguments);
}

///构建表信息行
mixin FlexibleTableInfoRowBuilderMixin<T> {
  Widget buildInfoRow(TableInfoRowArgumentsMixin<T> arguments);
}

mixin FlexibleTableRowBuilder<T> implements FlexibleTableRowBuilderMixin<T> {
  ///表内的全部列
  Set<AbsFlexibleTableColumn<T>> get allTableColumns;

  @protected
  Widget buildTableRow(
    TableBuildArgumentsMixin<T> arguments,
    Widget Function(AbsFlexibleTableColumn<T> column) buildCell,
  );

  @override
  Widget buildHeaderRow(TableBuildArgumentsMixin<T> arguments) {
    return buildTableRow(arguments, (column) => column.buildHeaderCell(arguments));
  }

  @override
  Widget buildInfoRow(TableInfoRowArgumentsMixin<T> arguments) {
    return buildTableRow(arguments, (column) => column.buildInfoCell(arguments));
  }

  ///根据列ID查找列配置类
  AbsFlexibleTableColumn<T>? findColumnById(Object columnId) {
    for (var column in allTableColumns) {
      var result = column.findColumnById(columnId);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  ///根据列ID查找可排序列配置类
  SortableTableColumnMixin<T>? findSortableColumnById(Object columnId) {
    return findColumnById(columnId) as SortableTableColumnMixin<T>?;
  }
}
