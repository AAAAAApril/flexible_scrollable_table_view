import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'dynamic_width.dart';

///拥有动态列宽的列
abstract class AbsDynamicWidthColumn<T> extends AbsFlexibleColumn<T> {
  const AbsDynamicWidthColumn(super.id);

  @override
  AbsDynamicWidth<T> get columnWidth;
}

class DynamicWidthColumn<T> extends AbsDynamicWidthColumn<T> {
  const DynamicWidthColumn(
    super.id, {
    required this.columnWidth,
    this.header,
    this.headerBuilder,
    this.info,
    this.infoBuilder,
  });

  @override
  final AbsDynamicWidth<T> columnWidth;

  final Widget? header;
  final Widget Function(AbsDynamicWidthColumn<T> column, TableHeaderRowBuildArguments<T> arguments)? headerBuilder;

  final Widget? info;
  final Widget Function(AbsDynamicWidthColumn<T> column, TableInfoRowBuildArguments<T> arguments)? infoBuilder;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      headerBuilder?.call(this, arguments) ?? header ?? const SizedBox.shrink();

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      infoBuilder?.call(this, arguments) ?? info ?? const SizedBox.shrink();
}
