import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
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
  final AbsFlexibleTableAnimations? animations;
  final int dataIndex;
  final T data;
  final double rowWidth;

  @override
  Widget build(BuildContext context) {
    final double height = configurations.fixedInfoRowHeight(controller, context, dataIndex, data);
    final BoxConstraints constraints = BoxConstraints.tight(
      Size(rowWidth, height),
    );
    Widget child = _FlexibleTableInfoRow<T>(
      controller,
      configurations: configurations,
      animations: animations,
      dataIndex: dataIndex,
      data: data,
      rowHeight: height,
    );
    if (animations != null) {
      child = animations!.buildConstraintAnimatedWidget(
        constraints,
        child,
      );
    } else {
      child = ConstrainedBox(
        constraints: constraints,
        child: child,
      );
    }
    return child;
  }
}

class _FlexibleTableInfoRow<T> extends StatelessWidget {
  const _FlexibleTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    required this.dataIndex,
    required this.data,
    required this.rowHeight,
    this.decorations,
    this.animations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations? animations;
  final int dataIndex;
  final T data;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final Widget pinned = PinnedTableInfoRow<T>(
      controller,
      configurations: configurations,
      animations: animations,
      dataIndex: dataIndex,
      data: data,
      height: rowHeight,
    );
    final Widget scrollable = ScrollableTableInfoRow<T>(
      controller,
      configurations: configurations,
      dataIndex: dataIndex,
      data: data,
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

    final Widget? foreground = decorations?.buildForegroundRowDecoration(
      controller,
      configurations,
      dataIndex,
      data,
    );
    final Widget? background = decorations?.buildBackgroundRowDecoration(
      controller,
      configurations,
      dataIndex,
      data,
    );
    if (foreground == null && background == null) {
      return child;
    }
    return Stack(children: [
      //背景行
      if (background != null) Positioned.fill(child: background),
      //内容行
      child,
      //前景行
      if (foreground != null) Positioned.fill(child: foreground),
    ]);
  }
}

///表信息行固定区域
class PinnedTableInfoRow<T> extends StatelessWidget {
  const PinnedTableInfoRow(
    this.controller, {
    super.key,
    required this.configurations,
    required this.dataIndex,
    this.animations,
    required this.data,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAnimations? animations;
  final int dataIndex;
  final T data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnInfoWidget<T>(
              controller,
              animations: animations,
              dataIndex: dataIndex,
              data: data,
              column: e,
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
    required this.dataIndex,
    required this.data,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final int dataIndex;
  final T data;
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
          dataIndex: dataIndex,
          data: data,
          column: columns[index],
          height: height,
        ),
      ),
    );
  }
}
