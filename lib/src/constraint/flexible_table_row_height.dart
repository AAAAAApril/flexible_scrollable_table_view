import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';

///行高
abstract class AbsFlexibleTableRowHeight<T> {
  const AbsFlexibleTableRowHeight();

  ///表头行高度
  double get headerRowHeight;

  ///表信息行高度
  double? get fixedInfoRowHeight;

  double? Function(TableInfoRowBuildArguments<T> arguments)? get infoRowHeightBuilder;

  ///信息行的固定高度
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments);
}

///固定高度
class FixedHeight<T> extends AbsFlexibleTableRowHeight<T> {
  const FixedHeight({
    required this.headerRowHeight,
    required this.fixedInfoRowHeight,
  });

  @override
  final double headerRowHeight;

  @override
  final double fixedInfoRowHeight;

  @override
  double? Function(TableInfoRowBuildArguments<T> arguments)? get infoRowHeightBuilder => null;

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) => fixedInfoRowHeight;
}

///根据数据变化
class ChangeableHeight<T> extends AbsFlexibleTableRowHeight<T> {
  const ChangeableHeight({
    required this.headerRowHeight,
    this.fixedInfoRowHeight,
    required this.infoRowHeightBuilder,
  });

  @override
  final double headerRowHeight;

  @override
  final double? fixedInfoRowHeight;

  @override
  final double? Function(TableInfoRowBuildArguments<T> arguments) infoRowHeightBuilder;

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) {
    return infoRowHeightBuilder.call(arguments) ?? fixedInfoRowHeight ?? 0;
  }
}
