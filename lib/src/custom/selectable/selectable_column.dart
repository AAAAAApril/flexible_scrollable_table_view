import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
class SelectableColumn<T> extends FlexibleColumn<T> {
  const SelectableColumn(
    super.id, {
    required super.fixedWidth,
    this.unSelectableWidth = 0,
    super.nameAlignment,
    super.infoAlignment,
    this.unSelectableNameAlignment = Alignment.center,
    this.unSelectableInfoAlignment = Alignment.center,
    required super.nameBuilder,
    required super.infoBuilder,
    this.unSelectableName,
    this.unSelectableInfo,
  });

  ///非可选状态时的固定宽度
  final double unSelectableWidth;

  ///非可选状态时的列名组件
  final TableColumnNameBuilder? unSelectableName;

  ///非可选状态时的列信息组件
  final TableColumnInfoBuilder<T>? unSelectableInfo;

  ///非可选状态时的列名组件对其方式
  final AlignmentGeometry unSelectableNameAlignment;

  ///非可选状态时的列信息组件对其方式
  final AlignmentGeometry unSelectableInfoAlignment;
}
