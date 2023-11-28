import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/column_width/appointed_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_state_widget.dart';
import 'package:flutter/widgets.dart';

///行中的列可伸缩的[行]构造器
///Tips：在父容器宽度不足时，所有的列宽使用 [AdaptedTableColumnConfig] 中的 [knownWidth]，否则使用 [unKnownWidth]
final class AdaptedRowBuilder<T> with FlexibleTableRowBuilder<T> {
  AdaptedRowBuilder(
    this._horizontalScrollMixin, {
    Set<AdaptedTableColumnConfig<T>>? leftPinnedColumns,
    Set<AdaptedTableColumnConfig<T>>? rightPinnedColumns,
    Set<AdaptedTableColumnConfig<T>>? scrollableColumns,
  })  : _leftPinnedColumns = List<AdaptedTableColumnConfig<T>>.of(leftPinnedColumns ?? <AdaptedTableColumnConfig<T>>[]),
        _rightPinnedColumns = List<AdaptedTableColumnConfig<T>>.of(rightPinnedColumns ?? <AdaptedTableColumnConfig<T>>[]),
        _scrollableColumns = List<AdaptedTableColumnConfig<T>>.of(scrollableColumns ?? <AdaptedTableColumnConfig<T>>[]);

  ///横向滚动控制器管理类
  final TableHorizontalScrollMixin _horizontalScrollMixin;

  final List<AdaptedTableColumnConfig<T>> _leftPinnedColumns;

  final List<AdaptedTableColumnConfig<T>> _rightPinnedColumns;

  final List<AdaptedTableColumnConfig<T>> _scrollableColumns;

  @override
  late final Set<AbsFlexibleTableColumn<T>> allTableColumns = <AbsFlexibleTableColumn<T>>{
    ..._leftPinnedColumns.map<AbsFlexibleTableColumn<T>>((e) => e.child),
    ..._scrollableColumns.map<AbsFlexibleTableColumn<T>>((e) => e.child),
    ..._rightPinnedColumns.map<AbsFlexibleTableColumn<T>>((e) => e.child),
  };

  ///获取所有列的总共已知列宽
  double getTotalKnownWidth(TableBuildArgumentsMixin<T> arguments) {
    return (List<AdaptedTableColumnConfig<T>>.of(_leftPinnedColumns)
          ..addAll(_scrollableColumns)
          ..addAll(_rightPinnedColumns))
        .fold<double>(0, (value, element) => value + element.knownWidth.getKnownWidth(arguments));
  }

  @override
  Widget buildTableRow(
    TableBuildArgumentsMixin<T> arguments,
    Widget Function(AbsFlexibleTableColumn<T> column) buildCell,
  ) {
    ///空间不足
    if (getTotalKnownWidth(arguments) >= arguments.parentWidth) {
      return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        ..._leftPinnedColumns.map<Widget>((e) {
          return e.knownWidth.constrainWidth(arguments, buildCell(e.child));
        }),
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
                itemBuilder: (context, index) {
                  final AdaptedTableColumnConfig<T> column = _scrollableColumns[index];
                  return column.knownWidth.constrainWidth(arguments, buildCell(column.child));
                },
              ),
            ),
          ),
        ..._rightPinnedColumns.map<Widget>((e) {
          return e.knownWidth.constrainWidth(arguments, buildCell(e.child));
        }),
      ]);
    }

    ///空间充足
    else {
      return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
        ..._leftPinnedColumns.map<Widget>((e) {
          return e.unKnownWidth.constrainWidth(arguments, buildCell(e.child));
        }),
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
                itemBuilder: (context, index) {
                  final AdaptedTableColumnConfig<T> column = _scrollableColumns[index];
                  return column.unKnownWidth.constrainWidth(arguments, buildCell(column.child));
                },
              ),
            ),
          ),
        ..._rightPinnedColumns.map<Widget>((e) {
          return e.unKnownWidth.constrainWidth(arguments, buildCell(e.child));
        }),
      ]);
    }
  }
}

///可伸缩的列宽
final class AdaptedTableColumnConfig<T> {
  const AdaptedTableColumnConfig(
    this.child, {
    required this.knownWidth,
    AppointedColumnWidth<T>? unKnownWidth,
  }) : unKnownWidth = unKnownWidth ?? knownWidth;

  ///真实的列配置类
  final AbsFlexibleTableColumn<T> child;

  ///已知的宽度
  final KnownColumnWidthMixin<T> knownWidth;

  ///未知的宽度
  final AppointedColumnWidth<T> unKnownWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptedTableColumnConfig && runtimeType == other.runtimeType && child == other.child;

  @override
  int get hashCode => child.hashCode;
}
