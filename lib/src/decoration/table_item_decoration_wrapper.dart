import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

///表头项装饰包装
class TableHeaderItemDecorationWrapper<T> extends StatelessWidget {
  const TableHeaderItemDecorationWrapper(
    this.arguments, {
    super.key,
    this.decorations,
    required this.column,
    required this.child,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleColumn<T> column;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

///表信息项装饰包装
class TableInfoItemDecorationWrapper<T> extends StatelessWidget {
  const TableInfoItemDecorationWrapper(
    this.arguments, {
    super.key,
    this.decorations,
    required this.column,
    required this.child,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleColumn<T> column;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
