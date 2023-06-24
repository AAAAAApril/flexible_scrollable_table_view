import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/widgets/flexible_table_info_cell.dart';
import 'package:flutter/widgets.dart';

///表信息行
class FlexibleTableInfoRow<T> extends StatelessWidget {
  const FlexibleTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
    this.physics,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: arguments.rowConstraint,
      child: _FlexibleTableInfoRow<T>(
        arguments,
        animations: animations,
        decorations: decorations,
        physics: physics,
      ),
    );
  }
}

class _FlexibleTableInfoRow<T> extends StatelessWidget {
  const _FlexibleTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
    this.physics,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      ...arguments.configurations.leftPinnedColumns.map<Widget>(
        (e) => FlexibleTableInfoCell<T>(
          arguments,
          animations: animations,
          decorations: decorations,
          column: e,
        ),
      ),
      if (arguments.configurations.scrollableColumns.isNotEmpty)
        Expanded(
          child: ScrollableTableInfoRow<T>(
            arguments,
            decorations: decorations,
            physics: physics,
          ),
        ),
      ...arguments.configurations.rightPinnedColumns.map<Widget>(
        (e) => FlexibleTableInfoCell<T>(
          arguments,
          animations: animations,
          decorations: decorations,
          column: e,
        ),
      ),
    ]);
    return decorations?.infoRowDecorationBuilder?.call(arguments, child) ?? child;
  }
}

///表信息行滚动区域
class ScrollableTableInfoRow<T> extends StatelessWidget {
  const ScrollableTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.physics,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: arguments.controller.horizontalScrollController,
      itemCount: arguments.scrollableColumnList.length,
      scrollDirection: Axis.horizontal,
      primary: false,
      padding: EdgeInsets.zero,
      physics: physics,
      itemBuilder: (context, index) => FlexibleTableInfoCell<T>(
        arguments,
        decorations: decorations,
        column: arguments.scrollableColumnList[index],
      ),
    );
  }
}
