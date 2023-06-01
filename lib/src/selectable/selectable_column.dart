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
  Widget buildHeader(BuildArguments<T> arguments) => buildSelectableHeader(arguments);

  ///构建可编辑时的表头
  Widget buildSelectableHeader(BuildArguments<T> arguments);

  ///构建不可编辑时的表头
  Widget buildUnSelectableHeader(BuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments.parentWidth));

  @override
  Widget buildInfo(BuildArguments<T> arguments, int dataIndex, T data) =>
      buildSelectableInfo(arguments, dataIndex, data);

  ///构建可编辑时的表信息
  Widget buildSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data);

  ///构建不可编辑时的表信息
  Widget buildUnSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data) =>
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
  final Widget Function(int dataIndex, T data) selectableInfo;
  final Widget Function(int dataIndex, T data)? unSelectableInfo;

  @override
  Widget buildSelectableHeader(BuildArguments<T> arguments) => selectableHeader;

  @override
  Widget buildUnSelectableHeader(BuildArguments<T> arguments) {
    return unSelectableHeader ?? super.buildUnSelectableHeader(arguments);
  }

  @override
  Widget buildSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data) =>
      selectableInfo.call(dataIndex, data);

  @override
  Widget buildUnSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data) {
    return unSelectableInfo?.call(dataIndex, data) ?? super.buildUnSelectableInfo(arguments, dataIndex, data);
  }
}
