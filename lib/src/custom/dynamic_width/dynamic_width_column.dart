import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'dynamic_width.dart';
import 'intrinsic_width_group.dart';

///拥有动态列宽的列
mixin DynamicWidthColumnMixin<T> on AbsFlexibleColumn<T> {
  @override
  AbsDynamicWidth<T> get columnWidth;

  @override
  Widget buildHeaderCellInternal(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return IntrinsicWidthChild(
      -1,
      dataSource: arguments.dataSource,
      group: columnWidth.widthGroup,
      fixedHeight: arguments.rowHeight,
      child: buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCellInternal(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return IntrinsicWidthChild(
      arguments.dataIndex,
      dataSource: arguments.dataSource,
      key: ValueKey<String>('${id}_${arguments.dataIndex}'),
      group: columnWidth.widthGroup,
      fixedHeight: arguments.rowHeight,
      child: buildInfoCell(arguments),
    );
  }
}

abstract class AbsDynamicWidthColumn<T> extends AbsFlexibleColumn<T> with DynamicWidthColumnMixin<T> {
  const AbsDynamicWidthColumn(super.id);
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
  final Widget Function(DynamicWidthColumnMixin<T> column, TableHeaderRowBuildArguments<T> arguments)? headerBuilder;

  final Widget? info;
  final Widget Function(DynamicWidthColumnMixin<T> column, TableInfoRowBuildArguments<T> arguments)? infoBuilder;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      headerBuilder?.call(this, arguments) ?? header ?? const SizedBox.shrink();

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      infoBuilder?.call(this, arguments) ?? info ?? const SizedBox.shrink();
}
