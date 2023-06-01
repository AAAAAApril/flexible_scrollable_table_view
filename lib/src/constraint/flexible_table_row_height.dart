import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';

///行高
abstract class AbsFlexibleTableRowHeight<T> {
  const AbsFlexibleTableRowHeight();

  ///表头行高度
  double get headerRowHeight;

  ///表信息行高度
  double? get fixedInfoRowHeight;

  double? Function(int dataIndex, T data)? get infoRowHeightBuilder;

  ///信息行的固定高度
  double infoRowHeight(FlexibleTableController<T> controller, int dataIndex, T data);
}

///固定高度
class FixedTableRowHeight<T> extends AbsFlexibleTableRowHeight<T> {
  const FixedTableRowHeight({
    required this.headerRowHeight,
    required this.fixedInfoRowHeight,
  });

  @override
  final double headerRowHeight;

  @override
  final double fixedInfoRowHeight;

  @override
  double? Function(int dataIndex, T data)? get infoRowHeightBuilder => null;

  @override
  double infoRowHeight(FlexibleTableController<T> controller, int dataIndex, T data) => fixedInfoRowHeight;
}

///根据数据变化
class ChangeableTableRowHeight<T> extends AbsFlexibleTableRowHeight<T> {
  const ChangeableTableRowHeight({
    required this.headerRowHeight,
    this.fixedInfoRowHeight,
    required this.infoRowHeightBuilder,
  });

  @override
  final double headerRowHeight;

  @override
  final double? fixedInfoRowHeight;

  @override
  final double? Function(int dataIndex, T data) infoRowHeightBuilder;

  @override
  double infoRowHeight(FlexibleTableController<T> controller, int dataIndex, T data) {
    return infoRowHeightBuilder.call(dataIndex, data) ?? fixedInfoRowHeight ?? 0;
  }
}
