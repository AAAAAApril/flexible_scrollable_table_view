import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///列头可点击列
final class HeaderPressableColumn<T> extends AbsFlexibleColumn<T> {
  HeaderPressableColumn(
    this._column, {
    required this.onHeaderClicked,
  }) : super('hpc_${_column.id}');

  final AbsFlexibleColumn<T> _column;

  final void Function(
    AbsFlexibleColumn<T> column,
    TableHeaderRowBuildArguments<T> arguments,
    BuildContext context,
  ) onHeaderClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return Builder(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onHeaderClicked.call(this, arguments, context),
        child: _column.buildHeaderCell(arguments),
      ),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return _column.buildInfoCell(arguments);
  }
}

///列信息可点击列
final class InfoPressableColumn<T> extends AbsFlexibleColumn<T> {
  InfoPressableColumn(
    this._column, {
    required this.onInfoClicked,
  }) : super('ipc_${_column.id}');

  final AbsFlexibleColumn<T> _column;

  final void Function(
    AbsFlexibleColumn<T> column,
    TableInfoRowBuildArguments<T> arguments,
    BuildContext context,
  ) onInfoClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return _column.buildHeaderCell(arguments);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return Builder(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onInfoClicked.call(this, arguments, context),
        child: _column.buildInfoCell(arguments),
      ),
    );
  }
}
