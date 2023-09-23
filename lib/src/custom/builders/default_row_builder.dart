import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_state_widget.dart';
import 'package:flutter/widgets.dart';

///默认的行构造器
final class DefaultRowBuilder<T> with FlexibleTableRowBuilder<T> {
  DefaultRowBuilder({
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
    required this.scrollMixin,
  })  : leftPinnedColumns = List<AbsFlexibleColumn<T>>.of(leftPinnedColumns ?? <AbsFlexibleColumn<T>>{}),
        rightPinnedColumns = List<AbsFlexibleColumn<T>>.of(rightPinnedColumns ?? <AbsFlexibleColumn<T>>{}),
        scrollableColumns = List<AbsFlexibleColumn<T>>.of(scrollableColumns ?? <AbsFlexibleColumn<T>>{});

  @protected
  final List<AbsFlexibleColumn<T>> leftPinnedColumns;

  @protected
  final List<AbsFlexibleColumn<T>> rightPinnedColumns;

  @protected
  final List<AbsFlexibleColumn<T>> scrollableColumns;

  ///横向滚动控制器管理类
  final TableHorizontalScrollMixin scrollMixin;

  @override
  Set<AbsFlexibleColumn<T>> get allTableColumns => <AbsFlexibleColumn<T>>{}
    ..addAll(leftPinnedColumns)
    ..addAll(scrollableColumns)
    ..addAll(rightPinnedColumns);

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return _buildRow(
      buildCell: (column) => buildColumnHeaderCell(column, arguments),
    );
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return _buildRow(
      buildCell: (column) => buildColumnInfoCell(column, arguments),
    );
  }

  Widget _buildRow({
    required Widget Function(AbsFlexibleColumn<T> column) buildCell,
  }) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      ...leftPinnedColumns.map<Widget>(buildCell),
      if (scrollableColumns.isNotEmpty)
        Expanded(
          child: TableHorizontalScrollStateWidget(
            scrollMixin,
            builder: (context, scrollController) => ListView.builder(
              controller: scrollController,
              itemCount: scrollableColumns.length,
              scrollDirection: Axis.horizontal,
              primary: false,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) => buildCell(scrollableColumns[index]),
            ),
          ),
        ),
      ...rightPinnedColumns.map<Widget>(buildCell),
    ]);
  }
}
