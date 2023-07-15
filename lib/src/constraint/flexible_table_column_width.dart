import 'dart:math';

import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';

///列宽
abstract class AbsFlexibleTableColumnWidth<T> {
  const AbsFlexibleTableColumnWidth();

  ///根据构建参数获取列宽
  double getColumnWidth(AbsTableBuildArguments<T> arguments);
}

///固定宽度
class FixedWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  const FixedWidth(this.fixedWidth);

  final double fixedWidth;

  @override
  double getColumnWidth(AbsTableBuildArguments<T> arguments) => fixedWidth;
}

///比例（相比于父容器的宽度比）
class ProportionalWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  ProportionalWidth(
    this.percent, {
    this.omittedWidth = 0,
  });

  ///percent of viewport width
  final double percent;

  ///不参与比例计算的宽度
  final double omittedWidth;

  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(AbsTableBuildArguments<T> arguments) {
    double? cacheWidth = _cache[arguments.parentWidth];
    if (cacheWidth == null) {
      cacheWidth = _widthFromParent(arguments.parentWidth);
      _cache[arguments.parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }

  double _widthFromParent(double parentWidth) {
    return (parentWidth - omittedWidth) * percent;
  }
}

///固定宽度或者比例
class FixedOrProportionalWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  FixedOrProportionalWidth.min({
    required this.fixed,
    required this.percent,
    this.omittedWidthOfParent = 0,
  }) : _min = true;

  FixedOrProportionalWidth.max({
    required this.fixed,
    required this.percent,
    this.omittedWidthOfParent = 0,
  }) : _min = false;

  ///固定宽度
  final double fixed;

  ///父容器宽度的比例
  final double percent;

  ///不参与比例计算的宽度
  final double omittedWidthOfParent;

  final bool _min;
  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(AbsTableBuildArguments<T> arguments) {
    double? cacheWidth = _cache[arguments.parentWidth];
    if (cacheWidth == null) {
      cacheWidth = _getWidth(arguments.parentWidth);
      _cache[arguments.parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }

  double _getWidth(double parentWidth) {
    final proportionalWidth = (parentWidth - omittedWidthOfParent) * percent;
    return _min ? min<double>(fixed, proportionalWidth) : max<double>(fixed, proportionalWidth);
  }
}
