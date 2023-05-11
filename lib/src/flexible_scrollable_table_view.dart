import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/material.dart';

import 'flexible_column.dart';
import 'widgets/table_view_content.dart';
import 'widgets/table_view_header.dart';

class FlexibleScrollableTableView<T> extends StatelessWidget {
  const FlexibleScrollableTableView({
    Key? key,
    required this.controller,
    required this.nameRowHeight,
    required this.infoRowHeight,
    required this.fixedColumns,
    required this.scrollableColumns,
    this.verticalScrollable = true,
  })  : assert(scrollableColumns.length > 0, 'At least one scrollable column is needed.'),
        super(key: key);

  ///控制器
  final FlexibleTableController<T> controller;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> fixedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///列名行的高度
  final double nameRowHeight;

  ///数据内容行的高度
  final double infoRowHeight;

  ///是否可以纵向滑动
  final bool verticalScrollable;

  @override
  Widget build(BuildContext context) {
    final Widget header = TableViewHeader<T>(
      controller,
      fixedColumns: fixedColumns,
      scrollableColumns: scrollableColumns,
      headerHeight: nameRowHeight,
    );
    final Widget content = TableViewContent<T>(
      controller,
      fixedColumns: fixedColumns,
      scrollableColumns: scrollableColumns,
      infoRowHeight: infoRowHeight,
    );

    if (verticalScrollable) {
      return Column(
        children: [
          header,
          Expanded(
            child: SingleChildScrollView(
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
