import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flutter/widgets.dart';

///表配置
class FlexibleTableConfigurations<T> {
  FlexibleTableConfigurations({
    required this.headerRowHeight,
    this.infoRowHeight,
    this.infoRowHeightBuilder,
    required this.pinnedColumns,
    required this.scrollableColumns,
  }) : assert(
          (infoRowHeight != null && infoRowHeight >= 0) || infoRowHeightBuilder != null,
          '要么固定高度，要么根据回调确定高度',
        );

  ///表头行高度
  final double headerRowHeight;

  ///表信息行高度
  final double? infoRowHeight;
  final double Function(BuildContext context, T data)? infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<AbsFlexibleColumn<T>> pinnedColumns;
  late final List<AbsFlexibleColumn<T>> pinnedColumnList = pinnedColumns.toList(growable: false);

  ///可以左右滑动的列
  final Set<AbsFlexibleColumn<T>> scrollableColumns;
  late final List<AbsFlexibleColumn<T>> scrollableColumnList = scrollableColumns.toList(growable: false);

  ///可选时，固定列的总宽度
  late final double _selectableAllPinnedColumnsWidth = _computeColumnsWith(pinnedColumns, true);

  ///不可选时，固定列的总宽度
  late final double _unSelectableAllPinnedColumnsWidth = _computeColumnsWith(pinnedColumns, false);

  ///固定列的总宽度
  double totalPinnedColumnWidth(bool selectable) =>
      selectable ? _selectableAllPinnedColumnsWidth : _unSelectableAllPinnedColumnsWidth;

  ///可选时，滚动列的总宽度
  late final double _selectableAllScrollableColumnsWidth = _computeColumnsWith(scrollableColumns, true);

  ///不可选时，滚动列的总宽度
  late final double _unSelectableAllScrollableColumnsWidth = _computeColumnsWith(scrollableColumns, false);

  ///滚动列的总宽度
  double totalScrollableColumnWidth(bool selectable) =>
      selectable ? _selectableAllScrollableColumnsWidth : _unSelectableAllScrollableColumnsWidth;

  ///计算所有列的宽度
  double _computeColumnsWith(Set<AbsFlexibleColumn<T>> columns, bool selectable) {
    return columns.fold<double>(0, (previousValue, element) {
      double currentWidth = element.fixedWidth;
      if (!selectable && element is SelectableColumn<T>) {
        currentWidth = element.unSelectableWidth;
      }
      return previousValue + currentWidth;
    });
  }

  ///信息行的固定高度
  double fixedInfoRowHeight(BuildContext context, T data) {
    return infoRowHeightBuilder?.call(context, data) ?? infoRowHeight!;
  }
}
