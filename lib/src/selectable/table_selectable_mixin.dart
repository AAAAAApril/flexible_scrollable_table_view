import 'package:flutter/foundation.dart';

///行可选择的功能
mixin TableSelectableMixin<T> on ChangeNotifier {
  ///可以被选择的数据
  List<T> get selectableValue;

  ///当前是否是可选中模式
  final ValueNotifier<bool> _selectable = ValueNotifier<bool>(false);

  ValueListenable<bool> get selectable => _selectable;

  ///被选中的数据
  final ValueNotifier<Set<T>> _selectedValue = ValueNotifier<Set<T>>(<T>{});

  ValueListenable<Set<T>> get selectedValue => _selectedValue;

  @override
  void dispose() {
    _selectedValue.dispose();
    _selectable.dispose();
    super.dispose();
  }

  //====================================================================================================================

  ///切换可选择状态
  void switchSelectable(bool selectable) {
    _selectable.value = selectable;
  }

  ///切换某一行的选中状态
  void toggleRowSelectState(T rowData) {
    if (isRowSelected(rowData)) {
      unselectRow(rowData);
    } else {
      selectRow(rowData);
    }
  }

  ///该数据对应的那一行是否被选中
  bool isRowSelected(T rowData) {
    return _selectedValue.value.contains(rowData);
  }

  ///选中某一行
  void selectRow(T rowData) {
    if (_selectedValue.value.add(rowData)) {
      _selectedValue.value = Set<T>.of(_selectedValue.value);
    }
  }

  ///取消选中某一行
  void unselectRow(T rowData) {
    if (_selectedValue.value.remove(rowData)) {
      _selectedValue.value = Set<T>.of(_selectedValue.value);
    }
  }

  ///选中某一些行
  void selectRows(Set<T> rowDataSet) {
    if (rowDataSet.isEmpty) {
      return;
    }
    _selectedValue.value = Set<T>.of(_selectedValue.value)..addAll(rowDataSet);
  }

  ///取消选中某一些行
  void unselectRows(Set<T> rowDataSet) {
    if (rowDataSet.isEmpty) {
      return;
    }
    _selectedValue.value = Set<T>.of(_selectedValue.value)..removeAll(rowDataSet);
  }

  ///选中全部行
  void selectAllRows() {
    _selectedValue.value = Set<T>.of(selectableValue);
  }

  ///取消选中全部行
  void unselectAllRows() {
    _selectedValue.value = <T>{};
  }

  ///在通知更新前 移除掉 所有 在 被选中列 包含，但 可选列 未包含的数据
  @override
  void notifyListeners() {
    final int oldLength = _selectedValue.value.length;
    if (oldLength > 0) {
      final List<T> selectableValue = List.of(this.selectableValue);
      _selectedValue.value.removeWhere((element) => !selectableValue.contains(element));
      if (oldLength != _selectedValue.value.length) {
        _selectedValue.value = Set<T>.of(_selectedValue.value);
      }
    }
    super.notifyListeners();
  }
}
