import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'widgets/table_view_content.dart';
import 'widgets/table_view_header.dart';

class FlexibleScrollableTableView<T> extends StatelessWidget {
  const FlexibleScrollableTableView(
    this.controller, {
    super.key,
    required this.columnController,
    this.verticalScrollable = true,
    this.verticalPhysics,
    this.horizontalPhysics,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列控制器
  final FlexibleColumnController<T> columnController;

  ///是否可以纵向滑动
  final bool verticalScrollable;

  final ScrollPhysics? verticalPhysics;
  final ScrollPhysics? horizontalPhysics;

  @override
  Widget build(BuildContext context) {
    final Widget header = TableViewHeader<T>(
      controller,
      columnController: columnController,
      physics: horizontalPhysics,
    );
    final Widget content = TableViewContent<T>(
      controller,
      columnController: columnController,
      physics: horizontalPhysics,
    );

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
