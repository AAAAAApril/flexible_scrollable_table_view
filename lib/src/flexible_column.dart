import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///列信息配置类
abstract class FlexibleColumn<T> {
  const FlexibleColumn(
    this.id, {
    required this.fixedWidth,
    this.comparator,
  });

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  final double fixedWidth;

  ///排序时会使用的回调（为 null 表示该列没有排序功能）
  final Comparator<T>? comparator;

  ///该列是否可比较
  bool get comparableColumn => comparator != null;

  ///构建表头
  Widget buildHeader(
    FlexibleTableController<T> controller,
    BuildContext context,
    Size fixedSize,
  );

  ///构建表信息
  Widget buildInfo(
    FlexibleTableController<T> controller,
    BuildContext context,
    Size fixedSize,
    int dataIndex,
    T data,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is FlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
