import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/horizontal_scroll_controller_builder.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行
class FlexibleTableInfoRow<T> extends StatelessWidget {
  const FlexibleTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;

  @override
  Widget build(BuildContext context) {
    return TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: arguments.rowConstraint,
      child: _FlexibleTableInfoRow<T>(
        arguments,
        animations: animations,
        decorations: decorations,
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
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableInfoRow<T>(
      arguments,
      animations: animations,
      decorations: decorations,
    );
    final Widget scrollable = ScrollableTableInfoRow<T>(
      arguments,
      decorations: decorations,
    );
    Widget child;
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
    return decorations?.infoRowDecorationBuilder?.call(arguments, child) ?? child;
  }
}

///表信息行固定区域
class PinnedTableInfoRow<T> extends StatelessWidget {
  const PinnedTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: arguments.configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnInfoWidget<T>(
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
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;

  @override
  Widget build(BuildContext context) {
    final List<AbsFlexibleColumn<T>> columns = arguments.configurations.scrollableColumns.toList(growable: false);
    return HorizontalScrollControllerBuilder<T>(
      arguments.controller,
      builder: (context, scrollController) => ListView.builder(
        controller: scrollController,
        itemCount: columns.length,
        scrollDirection: Axis.horizontal,
        primary: false,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => TableColumnInfoWidget<T>(
          arguments,
          decorations: decorations,
          column: columns[index],
        ),
      ),
    );
  }
}
