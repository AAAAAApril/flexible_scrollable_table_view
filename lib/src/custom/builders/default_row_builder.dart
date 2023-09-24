import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_state_widget.dart';
import 'package:flutter/widgets.dart';

///默认的 [行]构造器
final class DefaultRowBuilder<T> with FlexibleTableRowBuilder<T> {
  DefaultRowBuilder(
    this._horizontalScrollMixin, {
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  })  : _leftPinnedColumns = List<AbsFlexibleColumn<T>>.of(leftPinnedColumns ?? <AbsFlexibleColumn<T>>{}),
        _rightPinnedColumns = List<AbsFlexibleColumn<T>>.of(rightPinnedColumns ?? <AbsFlexibleColumn<T>>{}),
        _scrollableColumns = List<AbsFlexibleColumn<T>>.of(scrollableColumns ?? <AbsFlexibleColumn<T>>{});

  ///横向滚动控制器管理类
  final TableHorizontalScrollMixin _horizontalScrollMixin;

  @protected
  final List<AbsFlexibleColumn<T>> _leftPinnedColumns;

  @protected
  final List<AbsFlexibleColumn<T>> _rightPinnedColumns;

  @protected
  final List<AbsFlexibleColumn<T>> _scrollableColumns;

  @override
  late final Set<AbsFlexibleColumn<T>> allTableColumns = <AbsFlexibleColumn<T>>{
    ..._leftPinnedColumns,
    ..._scrollableColumns,
    ..._rightPinnedColumns,
  };

  @override
  Widget buildTableRow(Widget Function(AbsFlexibleColumn<T> column) buildCell) {
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
