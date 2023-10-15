import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';

import 'appointed_column_width.dart';

///父容器宽度保持某个比例
final class ProportionalWidth<T> extends AppointedColumnWidth<T> with KnownColumnWidthMixin<T> {
  ProportionalWidth(
    this.proportion, {
    this.omittedWidth = 0,
  }) : assert(proportion >= 0, 'The proportion of column width must not be negative value.');

  ///当前列占父容器宽度的比例
  final double proportion;

  ///不参与比例计算的宽度
  final double omittedWidth;

  final Map<double, double> _cache = <double, double>{};

  @override
  double getKnownWidth(TableBuildArgumentsMixin<T> arguments) {
    double? cacheWidth = _cache[arguments.parentWidth];
    if (cacheWidth == null) {
      cacheWidth = (arguments.parentWidth - omittedWidth) * proportion;
      _cache[arguments.parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }
}
