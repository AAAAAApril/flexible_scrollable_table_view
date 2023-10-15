import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_state_widget.dart';
import 'package:flutter/widgets.dart';

///默认的 [行]构造器
final class DefaultRowBuilder<T> with FlexibleTableRowBuilder<T> {
  DefaultRowBuilder(
    this._horizontalScrollMixin, {
    Set<AbsFlexibleTableColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleTableColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleTableColumn<T>>? scrollableColumns,
  })  : _leftPinnedColumns = List<AbsFlexibleTableColumn<T>>.of(leftPinnedColumns ?? <AbsFlexibleTableColumn<T>>{}),
        _rightPinnedColumns = List<AbsFlexibleTableColumn<T>>.of(rightPinnedColumns ?? <AbsFlexibleTableColumn<T>>{}),
        _scrollableColumns = List<AbsFlexibleTableColumn<T>>.of(scrollableColumns ?? <AbsFlexibleTableColumn<T>>{});

  ///横向滚动控制器管理类
  final TableHorizontalScrollMixin _horizontalScrollMixin;

  final List<AbsFlexibleTableColumn<T>> _leftPinnedColumns;

  final List<AbsFlexibleTableColumn<T>> _rightPinnedColumns;

  final List<AbsFlexibleTableColumn<T>> _scrollableColumns;

  @override
  late final Set<AbsFlexibleTableColumn<T>> allTableColumns = <AbsFlexibleTableColumn<T>>{
    ..._leftPinnedColumns,
    ..._scrollableColumns,
    ..._rightPinnedColumns,
  };

  @override
  Widget buildTableRow(
    TableBuildArgumentsMixin<T> arguments,
    Widget Function(AbsFlexibleTableColumn<T> column) buildCell,
  ) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      ..._leftPinnedColumns.map<Widget>(buildCell),
      if (_scrollableColumns.isNotEmpty)
        Expanded(
          child: TableHorizontalScrollStateWidget(
            _horizontalScrollMixin,
            builder: (context, scrollController) => ListView.builder(
              controller: scrollController,
              itemCount: _scrollableColumns.length,
              scrollDirection: Axis.horizontal,
              primary: false,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) => buildCell(_scrollableColumns[index]),
            ),
          ),
        ),
      ..._rightPinnedColumns.map<Widget>(buildCell),
    ]);
  }
}
