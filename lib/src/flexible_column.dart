import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///列信息配置类
abstract class AbsFlexibleColumn<T> {
  const AbsFlexibleColumn(this.id);

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  double get fixedWidth;

  ///排序时会使用的回调（为 null 表示该列没有排序功能）
  Comparator<T>? get comparator => null;

  ///该列是否可比较
  bool get comparableColumn => comparator != null;

  ///构建表头
  Widget buildHeader(FlexibleTableController<T> controller);

  ///构建表信息
  Widget buildInfo(FlexibleTableController<T> controller, int dataIndex, T data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsFlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class FlexibleColumn<T> extends AbsFlexibleColumn<T> {
  const FlexibleColumn(
    super.id, {
    required this.fixedWidth,
    required this.header,
    required this.info,
  });

  @override
  final double fixedWidth;

  final Widget Function(FlexibleTableController<T> controller) header;
  final Widget Function(FlexibleTableController<T> controller, int dataIndex, T data) info;

  @override
  Widget buildHeader(FlexibleTableController<T> controller) => header.call(controller);

  @override
  Widget buildInfo(FlexibleTableController<T> controller, int dataIndex, T data) =>
      info.call(controller, dataIndex, data);
}
