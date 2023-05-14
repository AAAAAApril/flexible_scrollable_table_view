import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/widgets.dart';

import 'flexible_column.dart';

///列头组件构建器
typedef TableColumnHeaderBuilder = Widget Function(
  BuildContext context,
  Size fixedSize,
);

///列信息组件构建器
typedef TableColumnInfoBuilder<T> = Widget Function(
  BuildContext context,
  FlexibleColumn<T> column,
  Size fixedSize,
  int dataIndex,
  T data,
);

///表信息行高度构建
typedef TableInfoRowHeightBuilder<T> = double Function(
  BuildContext context,
  T data,
);

///表内容行装饰构造器
typedef TableContentRowDecorationBuilder<T> = Widget Function(
  BuildContext context,
  double fixedHeight,
  int dataIndex,
  T data,
);

///列头点击事件
///@return [bool] 是否已处理完毕，列头点击事件会先于排序事件执行，如果点击事件返回 true，则不会执行排序操作。
typedef TableColumnHeaderPressedCallback<T> = bool Function(
  BuildContext context,
  FlexibleColumn<T> column,
);

///列信息点击事件
typedef TableColumnInfoPressedCallback<T> = void Function(
  BuildContext context,
  FlexibleColumn<T> column,
  T data,
);
