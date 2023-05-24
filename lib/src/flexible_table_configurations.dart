import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表配置
abstract class AbsFlexibleTableConfigurations<T> {
  const AbsFlexibleTableConfigurations();

  ///表头行高度
  double get headerRowHeight;

  ///表信息行高度
  double? get infoRowHeight;

  double? Function(BuildContext context, int dataIndex, T data)? get infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  Set<AbsFlexibleColumn<T>> get pinnedColumns;

  ///可以左右滑动的列
  Set<AbsFlexibleColumn<T>> get scrollableColumns;

  ///信息行的固定高度
  double fixedInfoRowHeight(FlexibleTableController<T> controller, BuildContext context, int dataIndex, T data);
}

class FlexibleTableConfigurations<T> extends AbsFlexibleTableConfigurations<T> {
  FlexibleTableConfigurations({
    this.headerRowHeight = 0,
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
  final double? Function(BuildContext context, int dataIndex, T data)? infoRowHeightBuilder;

  ///不能左右滑动的列（会堆积在左侧）
  @override
  final Set<AbsFlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  @override
  final Set<AbsFlexibleColumn<T>> scrollableColumns;

  ///信息行的固定高度
  @override
  double fixedInfoRowHeight(FlexibleTableController<T> controller, BuildContext context, int dataIndex, T data) {
    return infoRowHeightBuilder?.call(context, dataIndex, data) ?? infoRowHeight!;
  }
}
