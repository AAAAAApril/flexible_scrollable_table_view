import 'package:flutter/foundation.dart';

///行可选择的功能
mixin TableSelectableMixin<T> on ChangeNotifier {
  ///当前是否是可选中模式
  final ValueNotifier<bool> _selectable = ValueNotifier<bool>(false);

  ValueListenable<bool> get selectable => _selectable;

  ///被选中的数据
  final ValueNotifier<List<T>> _selectedValue = ValueNotifier<List<T>>(<T>[]);

  ValueListenable<List<T>> get selectedValue => _selectedValue;

  @override
  void dispose() {
    super.dispose();
    _selectedValue.dispose();
    _selectable.dispose();
  }

  ///可以被选择的数据
  List<T> get selectableValue;

  //====================================================================================================================

  ///切换可选择状态
  void switchSelectable(bool selectable) {
    _selectable.value = selectable;
  }

  ///切换某一行的选中状态
  void switchRowSelectState(T rowData) {
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
    if (!_selectedValue.value.contains(rowData)) {
      _selectedValue.value = List<T>.of(_selectedValue.value)..add(rowData);
    }
  }

  ///取消选中某一行
  void unselectRow(T rowData) {
    _selectedValue.value = List<T>.of(_selectedValue.value)..remove(rowData);
  }

  ///选中某一些行
  void selectRows(List<T> rowDataList) {
    if (rowDataList.isEmpty) {
      return;
    }
    rowDataList.removeWhere((element) => _selectedValue.value.contains(element));
    _selectedValue.value = List<T>.of(_selectedValue.value)..addAll(rowDataList);
  }

  ///取消选中某一些行
  void unselectRows(List<T> rowDataList) {
    if (rowDataList.isEmpty) {
      return;
    }
    _selectedValue.value = List<T>.of(_selectedValue.value)..removeWhere((element) => rowDataList.contains(element));
  }

  ///选中全部行
  void selectAllRows() {
    _selectedValue.value = List<T>.of(selectableValue);
  }

  ///取消选中全部行
  void unselectAllRows() {
    _selectedValue.value = <T>[];
  }

  ///可选数据列变更了
  ///需要移除掉所有在被选中列包含，但可选列未包含的数据
  @Deprecated('Use addValueSettingCallback(callback) instead.')
  @protected
  void onSelectableValueChanged() {
    if (_selectedValue.value.isEmpty) {
      //没有选中的，不需要处理
      return;
    }
    final List<T> allSelected = List<T>.of(_selectedValue.value);
    for (var element in _selectedValue.value) {
      //被选中列包含，但可选列未包含
      if (!selectableValue.contains(element)) {
        //移除
        allSelected.remove(element);
      }
    }
    _selectedValue.value = allSelected;
  }
}
