import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///列头可点击列
final class ClickableHeaderColumn<T> extends AbsFlexibleColumn<T> {
  ClickableHeaderColumn(
    this._column, {
    required this.onHeaderClicked,
  }) : super(_column.id);

  final AbsFlexibleColumn<T> _column;

  final void Function(TableHeaderRowBuildArguments<T> arguments) onHeaderClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onHeaderClicked.call(arguments),
      child: _column.buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return _column.buildInfoCell(arguments);
  }
}

///列信息可点击列
final class ClickableInfoColumn<T> extends AbsFlexibleColumn<T> {
  ClickableInfoColumn(
    this._column, {
    required this.onInfoClicked,
  }) : super(_column.id);

  final AbsFlexibleColumn<T> _column;

  final void Function(TableInfoRowBuildArguments<T> arguments) onInfoClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return _column.buildHeaderCell(arguments);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onInfoClicked.call(arguments),
      child: _column.buildInfoCell(arguments),
    );
  }
}
