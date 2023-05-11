import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'flexible_column_sort_type.dart';
import 'mixins/selectable_row_mixin.dart';
import 'mixins/sortable_column_mixin.dart';

abstract class FlexibleTableValueListenable<T> extends ValueListenable<T> {
  const FlexibleTableValueListenable() : super();

  T get tableValue;
}

///表控制器
///[T] 表数据实体
class FlexibleTableController<T> extends ChangeNotifier
    with SortableColumnMixin<T>, SelectableRowMixin<T>
    implements FlexibleTableValueListenable<List<T>> {
  FlexibleTableController({
    this.nextSortType = FlexibleColumnSortType.nextSortType,
  }) : super() {
    nameRowScrollController = ScrollController();
    dataAreaScrollController = ScrollController();
    nameRowScrollController.addListener(_onNameRowScrollUpdated);
    dataAreaScrollController.addListener(_onDataRowScrollUpdated);
  }

  @override
  void dispose() {
    dataAreaScrollController.removeListener(_onDataRowScrollUpdated);
    nameRowScrollController.removeListener(_onNameRowScrollUpdated);
    nameRowScrollController.dispose();
    dataAreaScrollController.dispose();
    super.dispose();
  }

  ///列名行横向滚动控制器
  late final ScrollController nameRowScrollController;

  ///数据区域横向滚动控制器
  late final ScrollController dataAreaScrollController;

  @override
  final FlexibleColumnSortType Function(FlexibleColumnSortType current) nextSortType;

  ///原始数据
  List<T> _rawValue = <T>[];

  @protected
  @override
  List<T> get selectableValue => _rawValue;

  @protected
  @override
  List<T> get sortableValue => _rawValue;

  @override
  List<T> get tableValue => _rawValue;

  @override
  List<T> get value => sortedValue;

  set value(List<T> newValue) {
    if (_rawValue == newValue || (_rawValue.isEmpty && newValue.isEmpty)) {
      return;
    }
    _rawValue = newValue;
    onSelectableValueChanged();
    sortData();
  }

  //====================================================================================================================

  ///列名行滚动更新
  void _onNameRowScrollUpdated() {
    if (nameRowScrollController.offset != dataAreaScrollController.offset && dataAreaScrollController.hasClients) {
      dataAreaScrollController.jumpTo(nameRowScrollController.offset);
    }
  }

  ///数据区域滚动更新
  void _onDataRowScrollUpdated() {
    if (nameRowScrollController.offset != dataAreaScrollController.offset && nameRowScrollController.hasClients) {
      nameRowScrollController.jumpTo(dataAreaScrollController.offset);
    }
  }
}
