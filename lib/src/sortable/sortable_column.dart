import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

///可排序 Column
abstract class AbsSortableColumn<T> extends AbsFlexibleColumn<T> {
  const AbsSortableColumn(super.id);

  @override
  Comparator<T> get comparator;
}

class SortableColumn<T> extends AbsSortableColumn<T> {
  const SortableColumn(
    super.id, {
    required this.columnWidth,
    required this.comparator,
    required this.header,
    required this.info,
  });

  @override
  final AbsFlexibleTableColumnWidth columnWidth;
  @override
  final Comparator<T> comparator;

  final Widget header;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, AbsSortableColumn<T> column) info;

  @override
  Widget buildHeader(TableHeaderRowBuildArguments<T> arguments) => header;

  @override
  Widget buildInfo(TableInfoRowBuildArguments<T> arguments) => info.call(arguments, this);
}
