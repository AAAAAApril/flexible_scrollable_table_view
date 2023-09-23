import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///宽度根据父容器比例计算的列
final class ProportionalWidthFlexibleColumn<T> extends AbsFlexibleColumn<T> {
  ProportionalWidthFlexibleColumn(
    this._column, {
    required this.percent,
    this.omittedWidth = 0,
  })  : assert(!percent.isNegative, 'The percent of column[${_column.id}] must not be negative value.'),
        super('pwfc_${_column.id}');

  final AbsFlexibleColumn<T> _column;

  ///当前列占父容器宽度的比例
  final double percent;

  ///不参与比例计算的宽度
  final double omittedWidth;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(
      width: _getColumnWidth(arguments.parentWidth),
      height: double.infinity,
      child: _column.buildHeaderCell(arguments),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(
      width: _getColumnWidth(arguments.parentWidth),
      height: double.infinity,
      child: _column.buildInfoCell(arguments),
    );
  }

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
