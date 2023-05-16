import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/selectable/selectable_column.dart';
import 'package:flutter/widgets.dart';

///表信息行高度构建
typedef TableInfoRowHeightBuilder<T> = double Function(
  BuildContext context,
  T data,
);

///表信息行装饰构造器
typedef TableInfoRowDecorationBuilder<T> = Widget Function(
  BuildContext context,
  double fixedHeight,
  int dataIndex,
  T data,
);

extension IterableFlexibleColumnExt<T> on Iterable<FlexibleColumn<T>> {
  bool get containsSelectableColumns {
    try {
      firstWhere((element) => element is SelectableColumn<T>);
      return true;
    } catch (_) {
      return false;
    }
  }
}
