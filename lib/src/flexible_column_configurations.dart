import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flutter/widgets.dart';

///表列控制器
class FlexibleColumnConfigurations<T> {
  const FlexibleColumnConfigurations({
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
  final TableInfoRowHeightBuilder<T>? infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///固定列的总宽度
  double pinnedColumnsWidth(bool selectable) => computeColumnsWith(pinnedColumns, selectable);

  ///滚动列的总宽度
  double scrollableColumnsWidth(bool selectable) => computeColumnsWith(scrollableColumns, selectable);

  ///计算所有列的宽度
  double computeColumnsWith(Set<FlexibleColumn<T>> columns, bool selectable) {
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
