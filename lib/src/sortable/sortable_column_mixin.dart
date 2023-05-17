import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
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
mixin SortableColumnMixin<T> on ChangeNotifier {
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
  final ValueNotifier<FlexibleColumnSortType> _sortingType =
      ValueNotifier<FlexibleColumnSortType>(FlexibleColumnSortType.normal);

  ValueListenable<FlexibleColumnSortType> get sortingType => _sortingType;

  ///触发排序的列
  final ValueNotifier<AbsFlexibleColumn<T>?> _sortingColumn = ValueNotifier<AbsFlexibleColumn<T>?>(null);

  ValueListenable<AbsFlexibleColumn<T>?> get sortingColumn => _sortingColumn;

  @override
  void dispose() {
    super.dispose();
    _sortingType.dispose();
    _sortingColumn.dispose();
  }

  ///被排序过的数据
  List<T> _sortedValue = <T>[];

  List<T> get sortedValue => _sortedValue;

  ///需要被排序的数据
  List<T> get sortableValue;

  //====================================================================================================================

  ///按某一列排序
  void sortByColumn(AbsFlexibleColumn<T> sortingColumn) {
    //该列没有排序功能
    if (!sortingColumn.comparableColumn) {
      return;
    }
    final AbsFlexibleColumn<T>? currentColumn = _sortingColumn.value;
    FlexibleColumnSortType currentSortType = _sortingType.value;
    //重复点击了列头
    if (currentColumn == null || currentColumn == sortingColumn) {
      //切换排序方式
      currentSortType = nextSortType(currentSortType);
    }
    //切换了列头
    else {
      //是默认排序方式
      if (currentSortType == FlexibleColumnSortType.normal) {
        //切换排序方式
        currentSortType = nextSortType(currentSortType);
      }
      //不是默认排序方式
      else {
        //不切换排序方式
      }
    }
    _sortingType.value = currentSortType;
    //先置空
    _sortingColumn.value = null;
    _sortingColumn.value = currentSortType == FlexibleColumnSortType.normal ? null : sortingColumn;
    //重新排序
    sortData();
  }

  ///重置排序状态
  void resetSortState() {
    _sortingColumn.value = null;
    _sortingType.value = FlexibleColumnSortType.normal;
    sortData();
  }

  //====================================================================================================================

  ///给数据排序
  void sortData() {
    final List<T> value = List<T>.of(sortableValue);
    final FlexibleColumnSortType sortType = _sortingType.value;
    final Comparator<T>? comparator = _sortingColumn.value?.comparator;
    if (value.isNotEmpty && sortType != FlexibleColumnSortType.normal && comparator != null) {
      value.sort(
        (a, b) {
          int result = comparator(a, b);
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
