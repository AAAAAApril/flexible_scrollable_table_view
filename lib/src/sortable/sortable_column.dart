import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_column_mixin.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_column_wrapper.dart';
import 'package:flutter/widgets.dart';

///可排序 Column
abstract class AbsSortableColumn<T> extends AbsFlexibleColumn<T> {
  const AbsSortableColumn(super.id);

  @override
  Comparator<T> get comparator;

  ///与排序状态无关的表头组件
  Widget? headerStatelessWidget() => null;

  ///与排序状态无关的表信息组件
  Widget? infoStatelessWidget() => null;

  ///正在排序的表头
  Widget buildSortingHeader(FlexibleColumnSortType sortType, Widget? child);

  ///没在排序的表头
  Widget buildUnsortedHeader(FlexibleColumnSortType sortType, Widget? child);

  ///正在排序的表信息
  Widget buildSortingInfo(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child);

  ///没在排序的表信息
  Widget buildUnsortedInfo(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child);

  @override
  Widget buildHeader(FlexibleTableController<T> controller) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.sortByColumn(this);
      },
      child: SizedBox.expand(
        child: SortableColumnWrapper<T>(
          controller,
          currentColumn: this,
          builder: (context, currentColumnSorting, sortingType, child) {
            return currentColumnSorting
                ? buildSortingHeader(sortingType, child)
                : buildUnsortedHeader(sortingType, child);
          },
          child: headerStatelessWidget(),
        ),
      ),
    );
  }

  @override
  Widget buildInfo(FlexibleTableController<T> controller, int dataIndex, T data) {
    return SortableColumnWrapper<T>(
      controller,
      currentColumn: this,
      builder: (context, currentColumnSorting, sortingType, child) {
        return currentColumnSorting
            ? buildSortingInfo(sortingType, dataIndex, data, child)
            : buildUnsortedInfo(sortingType, dataIndex, data, child);
      },
      child: infoStatelessWidget(),
    );
  }
}

class SortableColumn<T> extends AbsSortableColumn<T> {
  const SortableColumn(
    super.id, {
    required this.fixedWidth,
    required this.comparator,
    this.statelessHeader,
    this.statelessInfo,
    required this.sortingHeader,
    required this.unsortedHeader,
    required this.sortingInfo,
    required this.unsortedInfo,
  });

  @override
  final double fixedWidth;
  @override
  final Comparator<T> comparator;

  final Widget? statelessHeader;
  final Widget? statelessInfo;
  final Widget Function(FlexibleColumnSortType sortType, Widget? child) sortingHeader;
  final Widget Function(FlexibleColumnSortType sortType, Widget? child) unsortedHeader;
  final Widget Function(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child) sortingInfo;
  final Widget Function(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child) unsortedInfo;

  @override
  Widget? headerStatelessWidget() => statelessHeader;

  @override
  Widget? infoStatelessWidget() => statelessInfo;

  @override
  Widget buildSortingHeader(FlexibleColumnSortType sortType, Widget? child) => sortingHeader.call(sortType, child);

  @override
  Widget buildUnsortedHeader(FlexibleColumnSortType sortType, Widget? child) => unsortedHeader.call(sortType, child);

  @override
  Widget buildSortingInfo(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child) =>
      sortingInfo.call(sortType, dataIndex, data, child);

  @override
  Widget buildUnsortedInfo(FlexibleColumnSortType sortType, int dataIndex, T data, Widget? child) =>
      unsortedInfo.call(sortType, dataIndex, data, child);
}
