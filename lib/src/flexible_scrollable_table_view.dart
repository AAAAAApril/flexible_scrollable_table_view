import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decoration.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/widgets.dart';

import 'widgets/table_view_content.dart';
import 'widgets/table_view_header.dart';

class FlexibleScrollableTableView<T> extends StatelessWidget {
  const FlexibleScrollableTableView(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    this.foregroundRowDecoration,
    this.backgroundRowDecoration,
    this.verticalScrollable = true,
    this.verticalPhysics,
    this.horizontalPhysics,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumnConfigurations<T> columnConfigurations;

  ///行装饰器（前景）
  final TableInfoRowDecorationBuilder<T>? foregroundRowDecoration;

  ///行装饰器（背景）
  final TableInfoRowDecorationBuilder<T>? backgroundRowDecoration;

  ///是否可以纵向滑动
  final bool verticalScrollable;

  final ScrollPhysics? verticalPhysics;
  final ScrollPhysics? horizontalPhysics;

  @override
  Widget build(BuildContext context) {
    final Widget header = TableViewHeader<T>(
      controller,
      columnConfigurations: columnConfigurations,
      physics: horizontalPhysics,
    );
    Widget content = TableViewContent<T>(
      controller,
      columnConfigurations: columnConfigurations,
      physics: horizontalPhysics,
    );
    if (foregroundRowDecoration != null || backgroundRowDecoration != null) {
      content = Stack(children: [
        if (backgroundRowDecoration != null)
          FlexibleTableContentDecoration<T>(
            controller,
            columnConfigurations: columnConfigurations,
            rowDecorationBuilder: backgroundRowDecoration!,
          ),
        content,
        if (foregroundRowDecoration != null)
          FlexibleTableContentDecoration<T>(
            controller,
            columnConfigurations: columnConfigurations,
            rowDecorationBuilder: foregroundRowDecoration!,
          ),
      ]);
    }
    if (verticalScrollable) {
      return Column(
        children: [
          header,
          Expanded(
            child: SingleChildScrollView(
              physics: verticalPhysics,
              child: content,
            ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header,
          content,
        ],
      );
    }
  }
}
