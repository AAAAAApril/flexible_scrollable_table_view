import 'package:flutter/widgets.dart';

import 'flexible_column.dart';

///列名组件构建器
typedef TableColumnNameBuilder = Widget Function(
  BuildContext context,
  Size fixedSize,
);

///列信息组件构建器
typedef TableColumnInfoBuilder<T> = Widget Function(
  BuildContext context,
  Size fixedSize,
  T data,
);

///列名点击事件
///@return [bool] 是否已处理完毕，列名点击事件会先于排序事件执行，如果点击事件返回 true，则不会执行排序操作。
typedef TableColumnNamePressedCallback<T> = bool Function(BuildContext context, FlexibleColumn<T> column);

///列信息点击事件
typedef TableColumnInfoPressedCallback<T> = void Function(BuildContext context, FlexibleColumn<T> column, T data);
