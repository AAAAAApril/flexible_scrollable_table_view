import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_scrollable_wrapper.dart';
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
    this.decorations,
  });

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final int dataIndex;
  final T data;

  @override
  Widget build(BuildContext context) {
    final double height = configurations.fixedInfoRowHeight(context, dataIndex, data);
    final Widget pinned = PinnedTableInfoRow<T>(
      controller,
      configurations: configurations,
      dataIndex: dataIndex,
      data: data,
      height: height,
    );
    final Widget scrollable = ScrollableTableInfoRow<T>(
      controller,
      configurations: configurations,
      dataIndex: dataIndex,
      data: data,
      height: height,
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
    child = SizedBox.fromSize(
      size: Size(double.infinity, height),
      child: child,
    );

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: configurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnInfoWidget<T>(
              controller,
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
    return LayoutBuilder(
      builder: (p0, p1) => SizedBox.fromSize(
        size: Size(p1.maxWidth, height),
        child: TableContentRowScrollWrapper<T>(
          controller,
          columns: configurations.scrollableColumns,
          dataIndex: dataIndex,
          data: data,
          height: height,
        ),
      ),
    );
  }
}
