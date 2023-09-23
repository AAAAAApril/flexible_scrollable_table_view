import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///固定列宽的列
final class FixedWidthFlexibleColumn<T> extends AbsFlexibleColumn<T> {
  FixedWidthFlexibleColumn(
    this._column, {
    required this.fixedWidth,
  }) : super(_column.id);

  final AbsFlexibleColumn<T> _column;

  ///固定的宽度
  final double fixedWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(
      width: fixedWidth,
      height: double.infinity,
      child: _column.buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(
      width: fixedWidth,
      height: double.infinity,
      child: _column.buildInfoCell(arguments),
    );
  }
}
