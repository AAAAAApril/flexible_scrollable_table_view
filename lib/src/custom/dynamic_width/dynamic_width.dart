import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flutter/foundation.dart';

import 'intrinsic_width_group.dart';

///动态宽度
abstract class AbsDynamicWidth<T> extends AbsFlexibleTableColumnWidth<T> {
  AbsDynamicWidth(this.controller) {
    controller.addValueSettingCallback(_onValueSetting);
  }

  final FlexibleTableController<T> controller;

  ///宽度组
  IntrinsicWidthGroup get widthGroup;

  ///释放函数
  @mustCallSuper
  void dispose() {
    controller.removeValueSettingCallback(_onValueSetting);
  }

  void _onValueSetting(List<T> oldValue, List<T> newValue) {
    if (oldValue.length > newValue.length) {
      widthGroup.removeCacheAfter(newValue.length - 1);
    }
  }

  @override
  double getColumnWidth(AbsTableBuildArguments<T> arguments) {
    throw Exception('Instance of AbsDynamicWidth<T,I> only used in AbsDynamicWidthColumn<T,I> .');
  }
}

class DynamicWidth<T> extends AbsDynamicWidth<T> {
  DynamicWidth(
    super.controller, {
    this.minWidth,
    this.maxWidth,
  });

  final double? minWidth;
  final double? maxWidth;

  @override
  late final IntrinsicWidthGroup widthGroup = IntrinsicWidthGroup(
    widthLowerBound: minWidth,
    widthUpperBound: maxWidth,
  );

  @override
  void dispose() {
    super.dispose();
    widthGroup.dispose();
  }
}
