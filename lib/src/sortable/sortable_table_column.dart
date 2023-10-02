import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///可排序 Column
mixin SortableTableColumnMixin<T> on AbsFlexibleTableColumn<T> {
  int compare(T a, T b);
}

abstract class AbsSortableTableColumn<T> extends AbsFlexibleTableColumn<T> with SortableTableColumnMixin<T> {
  AbsSortableTableColumn(this._column) : super('asc_${_column.id}');

  final AbsFlexibleTableColumn<T> _column;

  void onPressedHeader(TableBuildArgumentsMixin<T> arguments) {
    if (arguments.dataSource.sortingColumn.value != this) {
      arguments.dataSource.switchSortColumn(this);
    } else {
      arguments.dataSource.switch2NextSortType();
    }
  }

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<T> arguments) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onPressedHeader(arguments),
      child: _column.buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<T> arguments) {
    return _column.buildInfoCell(arguments);
  }
}

final class SortableTableColumn<T> extends AbsSortableTableColumn<T> {
  SortableTableColumn(
    super.column, {
    required this.compareValue,
  });

  final int Function(SortableTableColumnMixin<T> column, T a, T b) compareValue;

  @override
  int compare(T a, T b) => compareValue.call(this, a, b);
}
