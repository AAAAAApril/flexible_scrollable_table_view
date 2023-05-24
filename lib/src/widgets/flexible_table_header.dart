import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
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
    this.animations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final BoxConstraints fixedConstraints = BoxConstraints.tight(
          Size(
            constraints.maxWidth,
            configurations.headerRowHeight,
          ),
        );
        final Widget child = _FlexibleTableHeader<T>(
          controller,
          configurations: configurations,
          animations: animations,
          physics: physics,
        );
        if (animations != null) {
          return animations!.buildConstraintAnimatedWidget(
            fixedConstraints,
            child,
          );
        }
        return ConstrainedBox(
          constraints: fixedConstraints,
          child: child,
        );
      },
    );
  }
}

class _FlexibleTableHeader<T> extends StatelessWidget {
  const _FlexibleTableHeader(
    this.controller, {
    super.key,
    required this.configurations,
    this.animations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations? animations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableHeaderRow<T>(
      controller,
      configurations: configurations,
      animations: animations,
    );
    final Widget scrollable = ScrollableTableHeaderRow<T>(
      controller,
      configurations: configurations,
      physics: physics,
    );
    final Widget child;
    if (configurations.pinnedColumns.isNotEmpty && configurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        pinned,
        Expanded(child: scrollable),
      ]);
    } else {
      if (configurations.scrollableColumns.isEmpty) {
        child = pinned;
      } else {
        child = scrollable;
      }
    }
    return child;
  }
}

///表头行固定区域
class PinnedTableHeaderRow<T> extends StatelessWidget {
  const PinnedTableHeaderRow(
    this.controller, {
    super.key,
    required this.configurations,
    this.animations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations? animations;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnHeaderWidget<T>(
              controller,
              animations: animations,
              column: e,
              height: configurations.headerRowHeight,
            ),
          )
          .toList(growable: false),
    );
  }
}

///表头行滚动区域
class ScrollableTableHeaderRow<T> extends StatelessWidget {
  const ScrollableTableHeaderRow(
    this.controller, {
    super.key,
    required this.configurations,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final List<AbsFlexibleColumn<T>> columns = configurations.scrollableColumns.toList(growable: false);
    return HorizontalScrollControllerBuilder<T>(
      controller,
      builder: (context, scrollController) => ListView.builder(
        controller: scrollController,
        itemCount: columns.length,
        scrollDirection: Axis.horizontal,
        primary: false,
        padding: EdgeInsets.zero,
        physics: physics,
        itemBuilder: (context, index) => TableColumnHeaderWidget<T>(
          controller,
          column: columns[index],
          height: configurations.headerRowHeight,
        ),
      ),
    );
  }
}
