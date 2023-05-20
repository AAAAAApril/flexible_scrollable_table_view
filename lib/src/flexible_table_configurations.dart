import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flutter/widgets.dart';

///表配置
abstract class AbsFlexibleTableConfigurations<T> {
  const AbsFlexibleTableConfigurations();

  ///表头行高度
  double get headerRowHeight;

  ///表信息行高度
  double? get infoRowHeight;

  double Function(BuildContext context, T data)? get infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  Set<AbsFlexibleColumn<T>> get pinnedColumns;

  ///可以左右滑动的列
  Set<AbsFlexibleColumn<T>> get scrollableColumns;

  ///信息行的固定高度
  double fixedInfoRowHeight(BuildContext context, T data);
}

class FlexibleTableConfigurations<T> extends AbsFlexibleTableConfigurations<T> {
  FlexibleTableConfigurations({
    required this.headerRowHeight,
    this.infoRowHeight,
    this.infoRowHeightBuilder,
    Set<AbsFlexibleColumn<T>>? pinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  })  : assert(
          (infoRowHeight != null && infoRowHeight >= 0) || infoRowHeightBuilder != null,
          '要么固定高度，要么根据回调确定高度',
        ),
        pinnedColumns = pinnedColumns ?? <AbsFlexibleColumn<T>>{},
        scrollableColumns = scrollableColumns ?? <AbsFlexibleColumn<T>>{};

  @override
  final double headerRowHeight;

  @override
  final double? infoRowHeight;
  @override
  final double Function(BuildContext context, T data)? infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  @override
  final Set<AbsFlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  @override
  final Set<AbsFlexibleColumn<T>> scrollableColumns;

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
      if (!selectable && element is AbsSelectableColumn<T>) {
        currentWidth = element.unSelectableWidth;
      }
      return previousValue + currentWidth;
    });
  }

  ///信息行的固定高度
  @override
  double fixedInfoRowHeight(BuildContext context, T data) {
    return infoRowHeightBuilder?.call(context, data) ?? infoRowHeight!;
  }
}
