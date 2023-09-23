import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///可排序 Column
mixin SortableColumnMixin<T> on AbsFlexibleColumn<T> {
  int compare(T a, T b);
}

abstract class AbsSortableColumn<T> extends AbsFlexibleColumn<T> with SortableColumnMixin<T> {
  AbsSortableColumn(this._column) : super(_column.id);

  final AbsFlexibleColumn<T> _column;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return _column.buildHeaderCell(arguments);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return _column.buildInfoCell(arguments);
  }
}

final class SortableColumn<T> extends AbsSortableColumn<T> {
  SortableColumn(
    super.column, {
    required this.compareValue,
  });

  final int Function(T a, T b) compareValue;

  @override
  int compare(T a, T b) => compareValue.call(a, b);
}
