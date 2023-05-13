import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';

///表列控制器
class FlexibleColumnController<T> {
  FlexibleColumnController({
    required this.headerRowHeight,
    this.infoRowHeight,
    this.infoRowHeightBuilder,
  }) : assert(infoRowHeight != null || infoRowHeightBuilder != null, '要么指定固定高度，要么根据回调确定高度');

  ///表头行高度
  final double headerRowHeight;

  ///表信息行高度
  final double? infoRowHeight;
  final TableInfoRowHeightBuilder<T>? infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> pinnedColumns = <FlexibleColumn<T>>{};

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns = <FlexibleColumn<T>>{};

  ///添加一个不动的列
  void addPinnedColumn(FlexibleColumn<T> column) {
    pinnedColumns.add(column);
  }

  ///添加一些不动的列
  void addPinnedColumns(Set<FlexibleColumn<T>> columns) {
    pinnedColumns.addAll(columns);
  }

  ///添加一个可动的列
  void addScrollableColumn(FlexibleColumn<T> column) {
    scrollableColumns.add(column);
  }

  ///添加一些可动的列
  void addScrollableColumns(Set<FlexibleColumn<T>> columns) {
    scrollableColumns.addAll(columns);
  }

  ///移除一个不动列
  void removePinnedColumn(FlexibleColumn<T> column) {
    pinnedColumns.remove(column);
  }

  ///移除一些不动列
  void removePinnedColumns(Set<FlexibleColumn<T>> columns) {
    pinnedColumns.removeAll(columns);
  }

  ///移除一个可动列
  void removeScrollableColumn(FlexibleColumn<T> column) {
    scrollableColumns.remove(column);
  }

  ///移除一些可动列
  void removeScrollableColumns(Set<FlexibleColumn<T>> columns) {
    scrollableColumns.removeAll(columns);
  }
}
