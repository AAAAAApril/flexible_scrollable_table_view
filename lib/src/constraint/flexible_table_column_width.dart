import 'dart:io';
import 'dart:math';

import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';

///列宽
abstract class AbsFlexibleTableColumnWidth<T> {
  const AbsFlexibleTableColumnWidth();

  ///在移动设备上，默认使用缓存，因为移动设备的屏幕宽度变更的可能性很小
  bool get useCache => Platform.isAndroid || Platform.isIOS;

  ///根据构建参数获取列宽
  double getColumnWidthByArguments(AbsTableBuildArguments<T> arguments) {
    return getColumnWidth(arguments.parentWidth, useCache: useCache);
  }

  ///根据父容器宽度，返回当前列宽度
  @Deprecated('Use getColumnWidthByArguments(AbsTableBuildArguments<T>) instead.')
  double getColumnWidth(double parentWidth, {bool? useCache});
}

///取固定宽度或者比例中的较大或较小值
class FlexibleWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  FlexibleWidth.min(this.widths)
      : assert(widths.length > 1, 'At least two widths is needed.'),
        _min = true;

  FlexibleWidth.max(this.widths)
      : assert(widths.length > 1, 'At least two widths is needed.'),
        _min = false;

  ///所有的需要用于比较的值
  final Set<AbsFlexibleTableColumnWidth<T>> widths;

  final bool _min;
  final Map<double, double> _cache = <double, double>{};

  @override
  double getColumnWidthByArguments(AbsTableBuildArguments<T> arguments) {
    if (!useCache) {
      return _widthFromParent(arguments);
    }
    double? result = _cache[arguments.parentWidth];
    if (result == null) {
      result = _widthFromParent(arguments);
      _cache[arguments.parentWidth] = result;
    }
    return result;
  }

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) => 0.0;

  double _widthFromParent(AbsTableBuildArguments<T> arguments) {
    return widths.fold<double>(
      _min ? double.infinity : 0,
      (previousValue, element) {
        if (_min) {
          return min<double>(
            previousValue,
            element.getColumnWidthByArguments(arguments),
          );
        }
        return max<double>(
          previousValue,
          element.getColumnWidthByArguments(arguments),
        );
      },
    );
  }
}

///固定宽度
class FixedWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  const FixedWidth(this.fixedWidth);

  final double fixedWidth;

  @override
  double getColumnWidthByArguments(AbsTableBuildArguments<T> arguments) => fixedWidth;

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) => 0.0;
}

///固定比例（相比于父容器的宽度比）
class ProportionalWidth<T> extends AbsFlexibleTableColumnWidth<T> {
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
  double getColumnWidthByArguments(AbsTableBuildArguments<T> arguments) {
    if (!useCache) {
      return _widthFromParent(arguments.parentWidth);
    }
    double? cacheWidth = _cache[arguments.parentWidth];
    if (cacheWidth == null) {
      cacheWidth = _widthFromParent(arguments.parentWidth);
      _cache[arguments.parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) => 0.0;

  double _widthFromParent(double parentWidth) {
    return (parentWidth - omittedWidth) * percent;
  }
}
