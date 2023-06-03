import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
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
    this.header,
    this.headerBuilder,
    this.info,
    this.infoBuilder,
  });

  @override
  final AbsFlexibleTableColumnWidth columnWidth;
  @override
  final Comparator<T> comparator;

  final Widget? header;
  final Widget Function(TableHeaderRowBuildArguments<T> arguments, AbsSortableColumn<T> column)? headerBuilder;

  final Widget? info;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, AbsSortableColumn<T> column)? infoBuilder;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      headerBuilder?.call(arguments, this) ?? header ?? const SizedBox.shrink();

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      infoBuilder?.call(arguments, this) ?? info ?? const SizedBox.shrink();
}
