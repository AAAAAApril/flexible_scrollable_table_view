import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

import 'appointed_row_height.dart';

///每次重新构建行时都可以改变行高
abstract final class ChangeableHeight<T> extends AppointedRowHeight<T> {
  const ChangeableHeight._();

  factory ChangeableHeight.info(
    double headerHeight, {
    required double Function(TableInfoRowArgumentsMixin<T> arguments) info,
  }) =>
      _FixedHeaderRowHeight<T>(headerHeight, infoHeight: info);

  factory ChangeableHeight.all({
    required double Function(TableBuildArgumentsMixin<T> arguments) header,
    required double Function(TableInfoRowArgumentsMixin<T> arguments) info,
  }) =>
      _ChangeableRowHeight<T>(headerHeight: header, infoHeight: info);

  double _getHeaderRowHeight(TableBuildArgumentsMixin<T> arguments);

  double _getInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments);

  @override
  Widget constrainHeaderRowHeight(TableBuildArgumentsMixin<T> arguments, Widget rowWidget) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: arguments.dataSource,
      builder: (context, value, child) => SizedBox(
        width: arguments.parentWidth,
        height: _getHeaderRowHeight(arguments),
        child: rowWidget,
      ),
    );
  }

  @override
  Widget constrainInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: _getInfoRowHeight(arguments), child: rowWidget);
  }
}

final class _ChangeableRowHeight<T> extends ChangeableHeight<T> {
  const _ChangeableRowHeight({
    required this.headerHeight,
    required this.infoHeight,
  }) : super._();

  final double Function(TableBuildArgumentsMixin<T> arguments) headerHeight;
  final double Function(TableInfoRowArgumentsMixin<T> arguments) infoHeight;

  @override
  double _getHeaderRowHeight(TableBuildArgumentsMixin<T> arguments) => headerHeight.call(arguments);

  @override
  double _getInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments) => infoHeight.call(arguments);
}

///固定表头行高度，表信息行高度可以在每次重新构建时改变
final class _FixedHeaderRowHeight<T> extends ChangeableHeight<T> {
  const _FixedHeaderRowHeight(
    this.headerHeight, {
    required this.infoHeight,
  }) : super._();

  final double headerHeight;
  final double Function(TableInfoRowArgumentsMixin<T> arguments) infoHeight;

  @override
  double _getHeaderRowHeight(TableBuildArgumentsMixin<T> arguments) => headerHeight;

  @override
  double _getInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments) => infoHeight.call(arguments);
}
