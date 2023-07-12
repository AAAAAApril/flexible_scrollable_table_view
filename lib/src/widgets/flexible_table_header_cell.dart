import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///列头组件
class FlexibleTableHeaderCell<T> extends StatelessWidget {
  const FlexibleTableHeaderCell(
    this.arguments, {
    super.key,
    this.animations,
    required this.column,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;

  ///列配置
  final AbsFlexibleColumn<T> column;

  @override
  Widget build(BuildContext context) {
    return column.buildHeaderCellInternal(arguments, animations);
  }
}
