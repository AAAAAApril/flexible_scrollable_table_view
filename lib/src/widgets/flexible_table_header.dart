import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/widgets/flexible_table_header_cell.dart';
import 'package:flutter/widgets.dart';

///表头（行）
class FlexibleTableHeader<T> extends StatelessWidget {
  const FlexibleTableHeader(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    this.animations,
    this.scrollController,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final SynchronizedScrollMixin? scrollController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LazyLayoutBuilder(
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
            scrollController: scrollController,
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
    this.scrollController,
    this.physics,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final SynchronizedScrollMixin? scrollController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Widget child = Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      ...arguments.configurations.leftPinnedColumns.map<Widget>(
        (e) => FlexibleTableHeaderCell<T>(
          arguments,
          animations: animations,
          column: e,
        ),
      ),
      if (arguments.configurations.scrollableColumns.isNotEmpty)
        Expanded(
          child: ScrollableTableHeaderRow<T>(
            arguments,
            scrollController: scrollController,
            physics: physics,
          ),
        ),
      ...arguments.configurations.rightPinnedColumns.map<Widget>(
        (e) => FlexibleTableHeaderCell<T>(
          arguments,
          animations: animations,
          column: e,
        ),
      ),
    ]);
    return decorations?.headerRowDecorationBuilder?.call(arguments, child) ?? child;
  }
}

///表头行滚动区域
class ScrollableTableHeaderRow<T> extends StatelessWidget {
  const ScrollableTableHeaderRow(
    this.arguments, {
    super.key,
    this.scrollController,
    this.physics,
  });

  final TableHeaderRowBuildArguments<T> arguments;
  final SynchronizedScrollMixin? scrollController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController ?? arguments.controller.horizontalScrollController,
      itemCount: arguments.scrollableColumnList.length,
      scrollDirection: Axis.horizontal,
      primary: false,
      padding: EdgeInsets.zero,
      physics: physics,
      itemBuilder: (context, index) => FlexibleTableHeaderCell<T>(
        arguments,
        column: arguments.scrollableColumnList[index],
      ),
    );
  }
}
