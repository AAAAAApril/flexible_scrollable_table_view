import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
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
  Widget buildHeader(TableHeaderRowBuildArguments<T> arguments) => buildSelectableHeader(arguments);

  ///构建可编辑时的表头
  Widget buildSelectableHeader(TableHeaderRowBuildArguments<T> arguments);

  ///构建不可编辑时的表头
  Widget buildUnSelectableHeader(TableHeaderRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments.parentWidth));

  @override
  Widget buildInfo(TableInfoRowBuildArguments<T> arguments) => buildSelectableInfo(arguments);

  ///构建可编辑时的表信息
  Widget buildSelectableInfo(TableInfoRowBuildArguments<T> arguments);

  ///构建不可编辑时的表信息
  Widget buildUnSelectableInfo(TableInfoRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments.parentWidth));
}

class SelectableColumn<T> extends AbsSelectableColumn<T> {
  const SelectableColumn(
    super.id, {
    required this.selectableWidth,
    this.unSelectableWidth = const FixedWidth(0),
    required this.selectableHeader,
    this.unSelectableHeader,
    required this.selectableInfo,
    this.unSelectableInfo,
  });

  @override
  final AbsFlexibleTableColumnWidth selectableWidth;

  @override
  final AbsFlexibleTableColumnWidth unSelectableWidth;

  final Widget selectableHeader;
  final Widget? unSelectableHeader;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, AbsSelectableColumn<T> column) selectableInfo;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, AbsSelectableColumn<T> column)? unSelectableInfo;

  @override
  Widget buildSelectableHeader(TableHeaderRowBuildArguments<T> arguments) => selectableHeader;

  @override
  Widget buildUnSelectableHeader(TableHeaderRowBuildArguments<T> arguments) {
    return unSelectableHeader ?? super.buildUnSelectableHeader(arguments);
  }

  @override
  Widget buildSelectableInfo(TableInfoRowBuildArguments<T> arguments) => selectableInfo.call(arguments, this);

  @override
  Widget buildUnSelectableInfo(TableInfoRowBuildArguments<T> arguments) {
    return unSelectableInfo?.call(arguments, this) ?? super.buildUnSelectableInfo(arguments);
  }
}
