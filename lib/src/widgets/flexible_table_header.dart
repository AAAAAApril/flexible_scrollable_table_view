import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_mixin.dart';
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
      builder: (context, constraints) => configurations.buildTableHeaderRow(
        arguments: TableHeaderRowBuildArguments<T>(
          controller,
          configurations,
          constraints.maxWidth,
        ),
        decorations: decorations,
        animations: animations,
        scrollController: scrollController,
        physics: physics,
      ),
    );
  }
}
