import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';

///定制化的可选中的 Column
class SelectableColumn<T> extends FlexibleColumn<T> {
  const SelectableColumn(
    super.id, {
    required super.fixedWidth,
    this.unSelectableWidth = 0,
    required super.headerBuilder,
    required super.infoBuilder,
    this.unSelectableHeader,
    this.unSelectableInfo,
  });

  ///非可选状态时的固定宽度
  final double unSelectableWidth;

  ///非可选状态时的列头组件
  final TableColumnHeaderBuilder? unSelectableHeader;

  ///非可选状态时的列信息组件
  final TableColumnInfoBuilder<T>? unSelectableInfo;
}
