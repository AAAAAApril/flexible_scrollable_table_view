import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
mixin SelectableColumnMixin<T> on AbsFlexibleColumn<T> {
  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (!selectable) {
          return child!;
        }
        return buildSelectableHeaderCell(arguments);
      },
      child: buildUnSelectableHeaderCell(arguments),
    );
  }

  ///构建可编辑时的表头
  @protected
  Widget buildSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建不可编辑时的表头
  @protected
  Widget buildUnSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (!selectable) {
          return child!;
        }
        return buildSelectableInfoCell(arguments);
      },
      child: buildUnSelectableInfoCell(arguments),
    );
  }

  ///构建可编辑时的表信息
  @protected
  Widget buildSelectableInfoCell(TableInfoRowBuildArguments<T> arguments);

  ///构建不可编辑时的表信息
  @protected
  Widget buildUnSelectableInfoCell(TableInfoRowBuildArguments<T> arguments);
}
