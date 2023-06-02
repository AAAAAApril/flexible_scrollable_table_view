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
    this.useCache = true,
  }) : _min = true;

  FlexibleWidth.max({
    required this.fixedWidth,
    required this.widthPercent,
    this.useCache = true,
  }) : _min = false;

  final double fixedWidth;

  //percent of viewport width
  final double widthPercent;

  ///是否使用缓存
  final bool useCache;

  final bool _min;
  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth) {
    if (!useCache) {
      return _widthFromParent(parentWidth);
    }
    double? result = _cache[parentWidth];
    if (result == null) {
      result = _widthFromParent(parentWidth);
      _cache[parentWidth] = result;
    }
    return result;
  }

  double _widthFromParent(double parentWidth) {
    if (_min) {
      return min<double>(parentWidth * widthPercent, fixedWidth);
    } else {
      return max<double>(parentWidth * widthPercent, fixedWidth);
    }
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
  ProportionalWidth(
    this.percent, {
    this.omittedWidth = 0,
    this.useCache = true,
  });

  //percent of viewport width
  final double percent;

  ///不参与比例计算的宽度
  final double omittedWidth;

  ///是否使用缓存
  final bool useCache;

  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth) {
    if (!useCache) {
      return _widthFromParent(parentWidth);
    }
    double? cacheWidth = _cache[parentWidth];
    if (cacheWidth == null) {
      cacheWidth = _widthFromParent(parentWidth);
      _cache[parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }

  double _widthFromParent(double parentWidth) {
    return (parentWidth - omittedWidth) * percent;
  }
}
