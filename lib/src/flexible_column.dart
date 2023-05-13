import 'functions.dart';

///列信息配置类
class FlexibleColumn<T> {
  const FlexibleColumn(
    this.id, {
    required this.fixedWidth,
    required this.headerBuilder,
    required this.infoBuilder,
    this.onColumnHeaderPressed,
    this.onColumnInfoPressed,
    this.comparator,
  });

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  final double fixedWidth;

  ///列头组件
  final TableColumnHeaderBuilder headerBuilder;

  ///列信息组件
  final TableColumnInfoBuilder<T> infoBuilder;

  ///点击了列头
  final TableColumnHeaderPressedCallback<T>? onColumnHeaderPressed;

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
