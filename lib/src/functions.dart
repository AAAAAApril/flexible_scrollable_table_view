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
