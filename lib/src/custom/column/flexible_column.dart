import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

mixin FixedWidthFlexibleColumnMixin<T> on AbsFlexibleColumn<T> {
  ///固定的宽度
  double get fixedWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments arguments) {
    return SizedBox(
      width: fixedWidth,
      height: double.infinity,
      child: buildHeaderCellContent(arguments),
    );
  }

  @protected
  Widget buildHeaderCellContent(TableHeaderRowBuildArguments arguments);

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments arguments) {
    return SizedBox(
      width: fixedWidth,
      height: double.infinity,
      child: buildInfoCellContent(arguments),
    );
  }

  @protected
  Widget buildInfoCellContent(TableInfoRowBuildArguments arguments);
}

mixin ProportionalWidthFlexibleColumnMixin<T> on AbsFlexibleColumn<T> {
  ///当前列占父容器宽度的比例
  double get percent;

  ///不参与比例计算的宽度
  double get omittedWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments arguments) {
    return SizedBox(
      width: _getColumnWidth(arguments.parentWidth),
      height: double.infinity,
      child: buildHeaderCellContent(arguments),
    );
  }

  @protected
  Widget buildHeaderCellContent(TableHeaderRowBuildArguments arguments);

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments arguments) {
    return SizedBox(
      width: _getColumnWidth(arguments.parentWidth),
      height: double.infinity,
      child: buildInfoCellContent(arguments),
    );
  }

  @protected
  Widget buildInfoCellContent(TableInfoRowBuildArguments arguments);

  final Map<double, double> _cache = <double, double>{};

  double _getColumnWidth(double parentWidth) {
    double? cacheWidth = _cache[parentWidth];
    if (cacheWidth == null) {
      cacheWidth = (parentWidth - omittedWidth) * percent;
      _cache[parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }
}
