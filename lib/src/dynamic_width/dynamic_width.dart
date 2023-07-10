import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/foundation.dart';

import 'intrinsic_width_group.dart';

///动态宽度
abstract class AbsDynamicWidth<T, I> extends AbsFlexibleTableColumnWidth {
  AbsDynamicWidth(this.controller) {
    controller.addValueSettingCallback(_onTableValueSetting);
  }

  final FlexibleTableController<T> controller;

  ///宽度组
  IntrinsicWidthGroup<I> get widthGroup;

  ///释放函数
  @mustCallSuper
  void dispose() {
    controller.removeValueSettingCallback(_onTableValueSetting);
  }

  void _onTableValueSetting(List<T> oldValue, List<T> newValue) {
    if (!widthGroup.keepChildWidth) {
      widthGroup.clearWidthCaches(notifyListeners: false);
    }
  }

  @override
  double getColumnWidth(double parentWidth, {bool? useCache}) {
    throw Exception('Instance of AbsDynamicWidth<T,I> only used in AbsDynamicWidthColumn<T,I> .');
  }
}

class DynamicWidth<T, I> extends AbsDynamicWidth<T, I> {
  DynamicWidth(
    super.controller, {
    this.useCache = false,
    this.minWidth,
    this.maxWidth,
  });

  final double? minWidth;
  final double? maxWidth;

  @override
  final bool useCache;

  @override
  late final IntrinsicWidthGroup<I> widthGroup = IntrinsicWidthGroup(
    keepChildWidth: useCache,
    widthLowerBound: minWidth,
    widthUpperBound: maxWidth,
  );

  @override
  void dispose() {
    super.dispose();
    widthGroup.dispose();
  }
}
