///列宽
abstract class AbsFlexibleTableColumnWidth {
  const AbsFlexibleTableColumnWidth();

  ///根据父容器宽度，返回当前列宽度
  double getColumnWidth(double parentWidth);
}

///固定宽度
class FixedTableColumnWidth extends AbsFlexibleTableColumnWidth {
  const FixedTableColumnWidth(this.fixedWidth);

  final double fixedWidth;

  @override
  double getColumnWidth(double parentWidth) => fixedWidth;
}

///固定比例（相比于父容器的宽度比）
class ProportionalTableColumnWidth extends AbsFlexibleTableColumnWidth {
  ProportionalTableColumnWidth(this.percent);

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
