import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/horizontal_scroll_controller_builder.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_header_widget.dart';
import 'package:flutter/widgets.dart';

///表头（行）
class FlexibleTableHeader<T> extends StatelessWidget {
  const FlexibleTableHeader(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    this.animations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TableHeaderRowBuildArguments<T> arguments = TableHeaderRowBuildArguments<T>(
          controller,
          configurations,
          constraints.maxWidth,
        );
        return TableConstraintAnimationWrapper<T>(
          animations: animations,
          constraints: arguments.rowConstraint,
          child: _FlexibleTableHeader<T>(
            arguments,
            decorations: decorations,
            animations: animations,
            physics: physics,
          ),
        );
      },
    );
  }
}

class _FlexibleTableHeader<T> extends StatelessWidget {
  const _FlexibleTableHeader(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
    this.physics,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableHeaderRow<T>(
      arguments,
      animations: animations,
      decorations: decorations,
    );
    final Widget scrollable = ScrollableTableHeaderRow<T>(
      arguments,
      decorations: decorations,
      physics: physics,
    );
    final Widget child;
    if (arguments.configurations.pinnedColumns.isNotEmpty && arguments.configurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        pinned,
        Expanded(child: scrollable),
      ]);
    } else {
      if (arguments.configurations.scrollableColumns.isEmpty) {
        child = pinned;
      } else {
        child = scrollable;
      }
    }
    return decorations?.headerRowDecorationBuilder?.call(arguments, child) ?? child;
  }
}

///表头行固定区域
class PinnedTableHeaderRow<T> extends StatelessWidget {
  const PinnedTableHeaderRow(
    this.arguments, {
    super.key,
    this.animations,
    this.decorations,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: arguments.configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnHeaderWidget<T>(
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

///表头行滚动区域
class ScrollableTableHeaderRow<T> extends StatelessWidget {
  const ScrollableTableHeaderRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.physics,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return HorizontalScrollControllerBuilder<T>(
      arguments.controller,
      builder: (context, scrollController) => ListView.builder(
        controller: scrollController,
        itemCount: arguments.scrollableColumnList.length,
        scrollDirection: Axis.horizontal,
        primary: false,
        padding: EdgeInsets.zero,
        physics: physics,
        itemBuilder: (context, index) => TableColumnHeaderWidget<T>(
          arguments,
          decorations: decorations,
          column: arguments.scrollableColumnList[index],
        ),
      ),
    );
  }
}
