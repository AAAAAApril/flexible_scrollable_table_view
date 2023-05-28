import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表头行装饰
class TableHeaderRowDecorationWrapper<T> extends StatelessWidget {
  const TableHeaderRowDecorationWrapper(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

///表信息行装饰
class TableInfoRowDecorationWrapper<T> extends StatelessWidget {
  const TableInfoRowDecorationWrapper(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    required this.dataIndex,
    required this.data,
    required this.child,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final int dataIndex;
  final T data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget? foreground = decorations?.buildForegroundRowDecoration(
      controller,
      configurations,
      dataIndex,
      data,
    );
    final Widget? background = decorations?.buildBackgroundRowDecoration(
      controller,
      configurations,
      dataIndex,
      data,
    );
    if (foreground == null && background == null) {
      return child;
    }
    return Stack(children: [
      //背景行
      if (background != null) Positioned.fill(child: background),
      //内容行
      child,
      //前景行
      if (foreground != null) Positioned.fill(child: foreground),
    ]);
  }
}
