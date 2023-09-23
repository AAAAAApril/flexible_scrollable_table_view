import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///会撑开空间的列
final class ExpandedFlexibleColumn<T> extends AbsFlexibleColumn<T> {
  ExpandedFlexibleColumn(
    this._column, {
    this.flex = 1,
    this.fit = FlexFit.tight,
  }) : super('efc_${_column.id}');

  final AbsFlexibleColumn<T> _column;
  final int flex;
  final FlexFit fit;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: _column.buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return Flexible(
      flex: flex,
      fit: fit,
      child: _column.buildInfoCell(arguments),
    );
  }
}
