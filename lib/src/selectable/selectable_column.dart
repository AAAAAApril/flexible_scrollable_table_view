import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
abstract class AbsSelectableColumn<T> extends AbsFlexibleColumn<T> {
  const AbsSelectableColumn(super.id);

  ///可选状态时的固定宽度
  AbsFlexibleTableColumnWidth get selectableWidth;

  ///非可选状态时的固定宽度
  AbsFlexibleTableColumnWidth get unSelectableWidth;

  @override
  AbsFlexibleTableColumnWidth get columnWidth => selectableWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) => buildSelectableHeaderCell(arguments);

  ///构建可编辑时的表头
  Widget buildSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建不可编辑时的表头
  Widget buildUnSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments.parentWidth));

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) => buildSelectableInfoCell(arguments);

  ///构建可编辑时的表信息
  Widget buildSelectableInfoCell(TableInfoRowBuildArguments<T> arguments);

  ///构建不可编辑时的表信息
  Widget buildUnSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments.parentWidth));
}

class SelectableColumn<T> extends AbsSelectableColumn<T> {
  const SelectableColumn(
    super.id, {
    required this.selectableWidth,
    this.unSelectableWidth = const FixedWidth(0),
    this.selectableHeader,
    this.selectableHeaderBuilder,
    this.unSelectableHeader,
    this.unSelectableHeaderBuilder,
    this.selectableInfo,
    this.selectableInfoBuilder,
    this.unSelectableInfo,
    this.unSelectableInfoBuilder,
  });

  @override
  final AbsFlexibleTableColumnWidth selectableWidth;

  @override
  final AbsFlexibleTableColumnWidth unSelectableWidth;

  final Widget? selectableHeader;
  final Widget Function(
    TableHeaderRowBuildArguments<T> arguments,
    AbsSelectableColumn<T> column,
  )? selectableHeaderBuilder;

  final Widget? unSelectableHeader;
  final Widget Function(
    TableHeaderRowBuildArguments<T> arguments,
    AbsSelectableColumn<T> column,
  )? unSelectableHeaderBuilder;

  final Widget? selectableInfo;
  final Widget Function(
    TableInfoRowBuildArguments<T> arguments,
    AbsSelectableColumn<T> column,
  )? selectableInfoBuilder;

  final Widget? unSelectableInfo;
  final Widget Function(
    TableInfoRowBuildArguments<T> arguments,
    AbsSelectableColumn<T> column,
  )? unSelectableInfoBuilder;

  @override
  Widget buildSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      selectableHeaderBuilder?.call(arguments, this) ?? selectableHeader ?? const SizedBox.shrink();

  @override
  Widget buildUnSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return unSelectableHeaderBuilder?.call(arguments, this) ??
        unSelectableHeader ??
        super.buildUnSelectableHeaderCell(arguments);
  }

  @override
  Widget buildSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      selectableInfoBuilder?.call(arguments, this) ?? selectableInfo ?? const SizedBox.shrink();

  @override
  Widget buildUnSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return unSelectableInfoBuilder?.call(arguments, this) ??
        unSelectableInfo ??
        super.buildUnSelectableInfoCell(arguments);
  }
}
