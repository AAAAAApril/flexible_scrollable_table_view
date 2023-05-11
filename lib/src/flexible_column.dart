import 'package:flutter/widgets.dart';

import 'functions.dart';

///列信息配置类
class FlexibleColumn<T> {
  const FlexibleColumn(
    this.id, {
    required this.fixedWidth,
    required this.name,
    required this.infoBuilder,
    this.nameAlignment = Alignment.center,
    this.infoAlignment = Alignment.center,
    this.onColumnNamePressed,
    this.onColumnInfoPressed,
    this.comparator,
  });

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  final double fixedWidth;

  ///列名组件
  final Widget Function(BuildContext context, Size fixedSize) name;

  ///列信息组件
  final Widget Function(BuildContext context, T data, Size fixedSize) infoBuilder;

  ///列名组件在容器内的对齐方式
  final AlignmentGeometry nameAlignment;

  ///列信息组件在容器内的对齐方式
  final AlignmentGeometry infoAlignment;

  ///点击了列名
  final TableColumnNamePressedCallback<T>? onColumnNamePressed;

  ///点击了列信息
  final TableColumnInfoPressedCallback<T>? onColumnInfoPressed;

  ///排序时会使用的回调（为 null 表示该列没有排序功能）
  final Comparator<T>? comparator;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
