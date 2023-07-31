import 'package:flexible_scrollable_table_view/src/sortable/sortable_column.dart';
import 'package:flutter/foundation.dart';

enum FlexibleColumnSortType {
  ///默认
  normal,

  ///升序
  ascending,

  ///降序
  descending;
}

///列可排序的功能
mixin TableSortableMixin<T> on ChangeNotifier {
  ///切换下一个排序方式
  FlexibleColumnSortType nextSortType(FlexibleColumnSortType current) {
    switch (current) {
      case FlexibleColumnSortType.normal:
        return FlexibleColumnSortType.descending;
      case FlexibleColumnSortType.ascending:
        return FlexibleColumnSortType.normal;
      case FlexibleColumnSortType.descending:
        return FlexibleColumnSortType.ascending;
    }
  }

  ///当前的排序方式
  final ValueNotifier<FlexibleColumnSortType> _currentSortingType =
      ValueNotifier<FlexibleColumnSortType>(FlexibleColumnSortType.normal);

  ValueListenable<FlexibleColumnSortType> get currentSortingType => _currentSortingType;

  ///触发排序的列
  final ValueNotifier<SortableColumnMixin<T>?> _currentSortingColumn = ValueNotifier<SortableColumnMixin<T>?>(null);

  ValueListenable<SortableColumnMixin<T>?> get currentSortingColumn => _currentSortingColumn;

  @override
  void dispose() {
    super.dispose();
    _currentSortingType.dispose();
    _currentSortingColumn.dispose();
  }

  ///被排序过的数据
  List<T> _sortedValue = <T>[];

  List<T> get sortedValue => _sortedValue;

  ///需要被排序的数据
  List<T> get sortableValue;

  //====================================================================================================================

  ///切换排序方式
  void switchSortType(FlexibleColumnSortType newSortType) {
    if (newSortType == _currentSortingType.value) {
      return;
    }
    _currentSortingType.value = newSortType;
    if (_currentSortingColumn.value != null) {
      sortData();
    }
  }

  ///切换到下一个排序方式
  void switch2NextSortType() {
    switchSortType(nextSortType(_currentSortingType.value));
  }

  ///切换排序列
  void switchSortColumn(SortableColumnMixin<T>? newSortColumn) {
    //排序列相同，不切换
    if (_currentSortingColumn.value == newSortColumn) {
      return;
    }
    _currentSortingColumn.value = newSortColumn;
    //重新排序
    sortData();
  }

  ///切换排序方式以及排序列
  void switchSortTypeAndColumn({
    required FlexibleColumnSortType newSortType,
    required SortableColumnMixin<T>? newSortColumn,
  }) {
    bool needSort = false;
    if (newSortType != _currentSortingType.value) {
      _currentSortingType.value = newSortType;
      needSort = true;
    }
    if (newSortColumn != _currentSortingColumn.value) {
      _currentSortingColumn.value = newSortColumn;
      needSort = true;
    }
    if (needSort) {
      sortData();
    }
  }

  //====================================================================================================================

  ///给数据排序
  @protected
  void sortData() {
    final List<T> value = List<T>.of(sortableValue);
    final FlexibleColumnSortType sortType = _currentSortingType.value;
    final SortableColumnMixin<T>? sortingColumn = _currentSortingColumn.value;
    if (value.isNotEmpty && sortType != FlexibleColumnSortType.normal && sortingColumn != null) {
      value.sort(
        (a, b) {
          int result = sortingColumn.compare(a, b);
          //降序的时候，取反
          if (sortType == FlexibleColumnSortType.descending) {
            result = -result;
          }
          return result;
        },
      );
    }

    _sortedValue = value;
    notifyListeners();
  }
}
