import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/horizontal_scroll_controller_builder.dart';
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
    final List<Widget> children = <Widget>[];
    if (arguments.configurations.leftPinnedColumns.isNotEmpty) {
      children.add(PinnedTableInfoRow<T>(
        arguments,
        pinnedColumns: arguments.configurations.leftPinnedColumns,
        animations: animations,
        decorations: decorations,
      ));
    }
    if (arguments.configurations.scrollableColumns.isNotEmpty) {
      children.add(ScrollableTableInfoRow<T>(
        arguments,
        decorations: decorations,
        physics: physics,
      ));
    }
    if (arguments.configurations.rightPinnedColumns.isNotEmpty) {
      children.add(PinnedTableInfoRow<T>(
        arguments,
        pinnedColumns: arguments.configurations.rightPinnedColumns,
        animations: animations,
        decorations: decorations,
      ));
    }
    Widget child;
    if (children.length == 1) {
      child = children.first;
    } else {
      child = Row(
        children: children.map<Widget>((e) {
          if (e is ScrollableTableInfoRow<T>) {
            return Expanded(child: e);
          }
          return e;
        }).toList(growable: false),
      );
    }
    return decorations?.infoRowDecorationBuilder?.call(arguments, child) ?? child;
  }
}

///表信息行固定区域
class PinnedTableInfoRow<T> extends StatelessWidget {
  const PinnedTableInfoRow(
    this.arguments, {
    super.key,
    required this.pinnedColumns,
    this.decorations,
    this.animations,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final Set<AbsFlexibleColumn<T>> pinnedColumns;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pinnedColumns
          .map<Widget>(
            (e) => FlexibleTableInfoCell<T>(
              arguments,
              animations: animations,
              decorations: decorations,
              column: e,
            ),
          )
          .toList(growable: false),
    );
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
    return HorizontalScrollControllerBuilder(
      arguments.controller,
      builder: (context, scrollController) => ListView.builder(
        controller: scrollController,
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
      ),
    );
  }
}
