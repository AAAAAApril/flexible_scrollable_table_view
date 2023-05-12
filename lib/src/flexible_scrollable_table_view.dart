import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'flexible_column.dart';
import 'widgets/table_view_content.dart';
import 'widgets/table_view_header.dart';

class FlexibleScrollableTableView<T> extends StatelessWidget {
  const FlexibleScrollableTableView({
    Key? key,
    required this.controller,
    required this.nameRowHeight,
    required this.infoRowHeight,
    this.verticalScrollable = true,
    this.verticalPhysics,
    this.horizontalPhysics,
    required this.pinnedColumns,
    required this.scrollableColumns,
  })  : assert(scrollableColumns.length > 0, 'At least one scrollable column is needed.'),
        super(key: key);

  ///控制器
  final FlexibleTableController<T> controller;

  ///不能左右滑动的列（会堆积在左侧）
  final Set<FlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  final Set<FlexibleColumn<T>> scrollableColumns;

  ///列名行的高度
  final double nameRowHeight;

  ///数据内容行的高度
  final double infoRowHeight;

  ///是否可以纵向滑动
  final bool verticalScrollable;

  final ScrollPhysics? verticalPhysics;
  final ScrollPhysics? horizontalPhysics;

  @override
  Widget build(BuildContext context) {
    final Widget header = TableViewHeader<T>(
      controller,
      pinnedColumns: pinnedColumns,
      scrollableColumns: scrollableColumns,
      headerHeight: nameRowHeight,
      physics: horizontalPhysics,
    );
    final Widget content = TableViewContent<T>(
      controller,
      pinnedColumns: pinnedColumns,
      scrollableColumns: scrollableColumns,
      infoRowHeight: infoRowHeight,
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
