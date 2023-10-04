import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///约定宽度的列
final class AppointWidthFlexibleColumn<T> extends AbsFlexibleTableColumnWithChild<T> {
  AppointWidthFlexibleColumn(
    this.child, {
    required this.width,
  }) : super(child.id);

  @override
  final AbsFlexibleTableColumn<T> child;
  final AppointedColumnWidth width;

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<T> arguments) {
    return width.constrainWidth(arguments, child.buildHeaderCell(arguments));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<T> arguments) {
    return width.constrainWidth(arguments, child.buildInfoCell(arguments));
  }
}

abstract class AppointedColumnWidth<T> {
  const AppointedColumnWidth();

  ///约束宽度
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell);
}

///固定的宽度
final class FixedWidth<T> extends AppointedColumnWidth<T> {
  const FixedWidth(this.fixedWidth)
      : assert(fixedWidth >= 0, 'The fixedWidth of column width must not be negative value.');

  final double fixedWidth;

  @override
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    return SizedBox(width: fixedWidth, height: double.infinity, child: columnCell);
  }
}

///父容器宽度保持某个比例
final class ProportionalWidth<T> extends AppointedColumnWidth<T> {
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
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    return SizedBox(width: _getWidth(arguments), height: double.infinity, child: columnCell);
  }

  double _getWidth(TableBuildArgumentsMixin<T> arguments) {
    double? cacheWidth = _cache[arguments.parentWidth];
    if (cacheWidth == null) {
      cacheWidth = (arguments.parentWidth - omittedWidth) * proportion;
      _cache[arguments.parentWidth] = cacheWidth;
    }
    return cacheWidth;
  }
}

///撑开空间
final class ExpandedWidth<T> extends AppointedColumnWidth<T> {
  const ExpandedWidth({
    this.flex = 1,
    this.fit = FlexFit.tight,
  });

  final int flex;
  final FlexFit fit;

  @override
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    return Flexible(flex: flex, fit: fit, child: columnCell);
  }
}
