import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/dynamic_width/intrinsic_width_group.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'dynamic_width.dart';

///拥有动态列宽的列
abstract class AbsDynamicWidthColumn<T, I> extends AbsFlexibleColumn<T> {
  AbsDynamicWidthColumn(super.id);

  @override
  AbsDynamicWidth<T, I> get columnWidth;

  ///列头项的唯一 id
  I getHeaderChildId(TableHeaderRowBuildArguments<T> arguments);

  ///列信息项的唯一 id
  I getInfoChildId(TableInfoRowBuildArguments<T> arguments);

  ///构建表头
  Widget buildDynamicHeaderCell(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return IntrinsicWidthChild<I>(
      getHeaderChildId(arguments),
      group: columnWidth.widthGroup,
      fixedHeight: arguments.rowHeight,
      child: arguments.rowHeight <= 0 ? const SizedBox.shrink() : buildHeaderCell(arguments),
    );
  }

  ///构建表信息
  Widget buildDynamicInfoCell(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return IntrinsicWidthChild<I>(
      getInfoChildId(arguments),
      group: columnWidth.widthGroup,
      fixedHeight: arguments.rowHeight,
      child: arguments.rowHeight <= 0 ? const SizedBox.shrink() : buildInfoCell(arguments),
    );
  }
}

class DynamicWidthColumn<T, I> extends AbsDynamicWidthColumn<T, I> {
  DynamicWidthColumn(
    super.id, {
    required this.columnWidth,
    required this.headerChildId,
    required this.infoChildId,
    this.header,
    this.headerBuilder,
    this.info,
    this.infoBuilder,
  });

  @override
  final AbsDynamicWidth<T, I> columnWidth;

  final I Function(AbsDynamicWidthColumn<T, I> column, TableHeaderRowBuildArguments<T> arguments) headerChildId;
  final I Function(AbsDynamicWidthColumn<T, I> column, TableInfoRowBuildArguments<T> arguments) infoChildId;

  final Widget? header;
  final Widget Function(AbsDynamicWidthColumn<T, I> column, TableHeaderRowBuildArguments<T> arguments)? headerBuilder;

  final Widget? info;
  final Widget Function(AbsDynamicWidthColumn<T, I> column, TableInfoRowBuildArguments<T> arguments)? infoBuilder;

  @override
  I getHeaderChildId(TableHeaderRowBuildArguments<T> arguments) => headerChildId.call(this, arguments);

  @override
  I getInfoChildId(TableInfoRowBuildArguments<T> arguments) => infoChildId.call(this, arguments);

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      headerBuilder?.call(this, arguments) ?? header ?? const SizedBox.shrink();

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      infoBuilder?.call(this, arguments) ?? info ?? const SizedBox.shrink();
}
