import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表头项装饰包装
class TableHeaderItemDecorationWrapper<T> extends StatelessWidget {
  const TableHeaderItemDecorationWrapper(
    this.controller, {
    super.key,
    required this.configurations,
    required this.decorations,
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

///表信息项装饰包装
class TableInfoItemDecorationWrapper<T> extends StatelessWidget {
  const TableInfoItemDecorationWrapper(
    this.controller, {
    super.key,
    required this.configurations,
    required this.decorations,
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
    return child;
  }
}
