import 'dart:io';
import 'dart:math';

///列宽
abstract class AbsFlexibleTableColumnWidth {
  const AbsFlexibleTableColumnWidth();

  ///在移动设备上，默认使用缓存，因为移动设备的屏幕宽度变更的可能性很小
  bool get useCache => Platform.isAndroid || Platform.isIOS;

  ///根据父容器宽度，返回当前列宽度
  double getColumnWidth(double parentWidth, {bool? useCache});
}

///取固定宽度或者比例中的较大或较小值
class FlexibleWidth extends AbsFlexibleTableColumnWidth {
  FlexibleWidth.min(this.widths)
      : assert(widths.length > 1, 'At least two widths is needed.'),
        _min = true;

  FlexibleWidth.max(this.widths)
      : assert(widths.length > 1, 'At least two widths is needed.'),
        _min = false;

  ///所有的需要用于比较的值
  final Set<AbsFlexibleTableColumnWidth> widths;

  final bool _min;
  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) {
    if (!(useCache ?? this.useCache)) {
      return _widthFromParent(parentWidth, useCache: false);
    }
    double? result = _cache[parentWidth];
    if (result == null) {
      result = _widthFromParent(parentWidth, useCache: true);
      _cache[parentWidth] = result;
    }
    return result;
  }

  double _widthFromParent(
    double parentWidth, {
    required bool useCache,
  }) {
    return widths.fold<double>(
      _min ? double.infinity : 0,
      (previousValue, element) {
        if (_min) {
          return min<double>(
            previousValue,
            element.getColumnWidth(
              parentWidth,
              useCache: useCache,
            ),
          );
        }
        return max<double>(
          previousValue,
          element.getColumnWidth(
            parentWidth,
            useCache: useCache,
          ),
        );
      },
    );
  }
}

///固定宽度
class FixedWidth extends AbsFlexibleTableColumnWidth {
  const FixedWidth(this.fixedWidth);

  final double fixedWidth;

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) => fixedWidth;
}

///固定比例（相比于父容器的宽度比）
class ProportionalWidth extends AbsFlexibleTableColumnWidth {
  ProportionalWidth(
    this.percent, {
    this.omittedWidth = 0,
  });

  //percent of viewport width
  final double percent;

  ///不参与比例计算的宽度
  final double omittedWidth;

  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) {
    if (!(useCache ?? this.useCache)) {
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
