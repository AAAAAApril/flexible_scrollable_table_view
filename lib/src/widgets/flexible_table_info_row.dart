import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/animation/table_constraint_animation_wrapper.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/horizontal_scroll_controller_builder.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行
class FlexibleTableInfoRow<T> extends StatelessWidget {
  const FlexibleTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    required this.dataIndex,
    required this.data,
    required this.rowWidth,
    this.decorations,
    this.animations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final int dataIndex;
  final T data;
  final double rowWidth;

  @override
  Widget build(BuildContext context) {
    final double height = configurations.rowHeight.infoRowHeight(controller, dataIndex, data);
    return TableInfoRowConstraintAnimationWrapper<T>(
      controller,
      animations: animations,
      constraints: BoxConstraints.tight(Size(rowWidth, height)),
      dataIndex: dataIndex,
      data: data,
      child: _FlexibleTableInfoRow<T>(
        controller,
        configurations: configurations,
        animations: animations,
        decorations: decorations,
        dataIndex: dataIndex,
        data: data,
        parentWidth: rowWidth,
        rowHeight: height,
      ),
    );
  }
}

class _FlexibleTableInfoRow<T> extends StatelessWidget {
  const _FlexibleTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    required this.dataIndex,
    required this.data,
    required this.parentWidth,
    required this.rowHeight,
    this.decorations,
    this.animations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final int dataIndex;
  final T data;
  final double parentWidth;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableInfoRow<T>(
      controller,
      configurations: configurations,
      animations: animations,
      decorations: decorations,
      dataIndex: dataIndex,
      data: data,
      parentWidth: parentWidth,
      height: rowHeight,
    );
    final Widget scrollable = ScrollableTableInfoRow<T>(
      controller,
      configurations: configurations,
      decorations: decorations,
      dataIndex: dataIndex,
      data: data,
      parentWidth: parentWidth,
      height: rowHeight,
    );
    Widget child;
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
    return decorations?.infoRowDecorationBuilder?.call(
          controller,
          configurations,
          dataIndex,
          data,
          child,
        ) ??
        child;
  }
}

///表信息行固定区域
class PinnedTableInfoRow<T> extends StatelessWidget {
  const PinnedTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    required this.dataIndex,
    this.animations,
    required this.data,
    required this.parentWidth,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations<T>? animations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final int dataIndex;
  final T data;
  final double parentWidth;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnInfoWidget<T>(
              controller,
              configurations: configurations,
              animations: animations,
              decorations: decorations,
              dataIndex: dataIndex,
              data: data,
              column: e,
              parentWidth: parentWidth,
              height: height,
            ),
          )
          .toList(growable: false),
    );
  }
}

///表信息行滚动区域
class ScrollableTableInfoRow<T> extends StatelessWidget {
  const ScrollableTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    this.decorations,
    required this.dataIndex,
    required this.data,
    required this.parentWidth,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final int dataIndex;
  final T data;
  final double parentWidth;
  final double height;

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
        itemBuilder: (context, index) => TableColumnInfoWidget<T>(
          controller,
          configurations: configurations,
          decorations: decorations,
          dataIndex: dataIndex,
          data: data,
          column: columns[index],
          parentWidth: parentWidth,
          height: height,
        ),
      ),
    );
  }
}
