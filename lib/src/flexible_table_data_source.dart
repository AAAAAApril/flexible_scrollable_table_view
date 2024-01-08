import 'package:flexible_scrollable_table_view/src/sortable/sortable_table_column.dart';
import 'package:flutter/foundation.dart';

import 'selectable/table_selectable_mixin.dart';

///表数据源
///[T] 表数据实体
class FlexibleTableDataSource<T> extends ChangeNotifier
    with TableSelectableMixin<T>
    implements ValueListenable<List<T>> {
  FlexibleTableDataSource() : super();

  List<T> get rawValue => _rawValue;

  @override
  List<T> get value => _sortedValue;

  @override
  List<T> get selectableValue => _rawValue;

  ///当前的排序方式
  final ValueNotifier<FlexibleTableSortType> _currentSortingType = ValueNotifier(FlexibleTableSortType.normal);

  ValueListenable<FlexibleTableSortType> get sortingType => _currentSortingType;

  ///触发排序的列
  final ValueNotifier<SortableTableColumnMixin<T>?> _currentSortingColumn = ValueNotifier(null);

  ValueListenable<SortableTableColumnMixin<T>?> get sortingColumn => _currentSortingColumn;

  //====================================================================================================================

  ///获取下一个排序方式
  FlexibleTableSortType getNextSortType(FlexibleTableSortType current) {
    switch (current) {
      case FlexibleTableSortType.normal:
        return FlexibleTableSortType.descending;
      case FlexibleTableSortType.ascending:
        return FlexibleTableSortType.normal;
      case FlexibleTableSortType.descending:
        return FlexibleTableSortType.ascending;
    }
  }

  ///切换排序方式
  void switchSortType(FlexibleTableSortType newSortType) {
    if (newSortType == _currentSortingType.value) {
      return;
    }
    _currentSortingType.value = newSortType;
    if (_currentSortingColumn.value != null) {
      notifyListeners();
    }
  }

  ///切换到下一个排序方式
  void switch2NextSortType() {
    switchSortType(getNextSortType(_currentSortingType.value));
  }

  ///切换排序列
  void switchSortColumn(SortableTableColumnMixin<T>? newSortColumn) {
    //排序列相同，不切换
    if (_currentSortingColumn.value == newSortColumn) {
      return;
    }
    _currentSortingColumn.value = newSortColumn;
    //重新排序
    notifyListeners();
  }

  ///切换排序方式以及排序列
  void switchSortTypeAndColumn({
    required FlexibleTableSortType newSortType,
    required SortableTableColumnMixin<T>? newSortColumn,
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
      notifyListeners();
    }
  }

  //====================================================================================================================

  @protected
  List<T> sortValue() {
    final List<T> value = List<T>.of(_rawValue);
    final FlexibleTableSortType sortType = _currentSortingType.value;
    final SortableTableColumnMixin<T>? sortingColumn = _currentSortingColumn.value;
    if (value.isNotEmpty && sortType != FlexibleTableSortType.normal && sortingColumn != null) {
      value.sort(
        (a, b) {
          int result = sortingColumn.compare(a, b);
          //降序的时候，取反
          if (sortType == FlexibleTableSortType.descending) {
            result = -result;
          }
          return result;
        },
      );
    }
    return value;
  }

  ///通知数据更新之前先给数据排序
  @override
  void notifyListeners() {
    _sortedValue = sortValue();
    super.notifyListeners();
  }

  //====================================================================================================================

  ///原始数据
  List<T> _rawValue = <T>[];

  ///排过序的数据
  List<T> _sortedValue = <T>[];

  set value(List<T> newValue) {
    if (_rawValue == newValue) {
      return;
    }
    _rawValue = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    _currentSortingColumn.dispose();
    _currentSortingType.dispose();
    super.dispose();
  }
}

enum FlexibleTableSortType {
  ///默认
  normal,

  ///升序
  ascending,

  ///降序
  descending;
}
