import 'dart:math';

///列宽
abstract class AbsFlexibleTableColumnWidth {
  const AbsFlexibleTableColumnWidth();

  ///根据父容器宽度，返回当前列宽度
  double getColumnWidth(double parentWidth);
}

///取固定宽度或者比例中的较大或较小值
class FlexibleWidth extends AbsFlexibleTableColumnWidth {
  FlexibleWidth.min({
    required this.fixedWidth,
    required this.widthPercent,
  }) : _min = true;

  FlexibleWidth.max({
    required this.fixedWidth,
    required this.widthPercent,
  }) : _min = false;

  final double fixedWidth;

  //percent of viewport width
  final double widthPercent;

  final bool _min;
  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth) {
    double? result = _cache[parentWidth];
    if (result == null) {
      final percentWidth = parentWidth * widthPercent;
      if (_min) {
        result = min(percentWidth, fixedWidth);
      } else {
        result = max(percentWidth, fixedWidth);
      }
      _cache[parentWidth] = result;
    }
    return result;
  }
}

///固定宽度
class FixedWidth extends AbsFlexibleTableColumnWidth {
  const FixedWidth(this.fixedWidth);

  final double fixedWidth;

  @override
  double getColumnWidth(double parentWidth) => fixedWidth;
}

///固定比例（相比于父容器的宽度比）
class ProportionalWidth extends AbsFlexibleTableColumnWidth {
  ProportionalWidth(this.percent);

  //percent of viewport width
  final double percent;

  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth) {
    double? cacheWidth = _cache[parentWidth];
    if (cacheWidth == null) {
      cacheWidth = parentWidth * percent;
      _cache[parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }
}
