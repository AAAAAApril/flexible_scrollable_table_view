import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///列信息配置类
abstract class AbsFlexibleColumn<T> {
  const AbsFlexibleColumn(this.id);

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  AbsFlexibleTableColumnWidth get columnWidth;

  ///排序时会使用的回调（为 null 表示该列没有排序功能）
  Comparator<T>? get comparator => null;

  ///该列是否可比较
  bool get comparableColumn => comparator != null;

  ///构建表头
  Widget buildHeader(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    double parentWidth,
  );

  ///构建表信息
  Widget buildInfo(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    double parentWidth,
    int dataIndex,
    T data,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsFlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class FlexibleColumn<T> extends AbsFlexibleColumn<T> {
  const FlexibleColumn(
    super.id, {
    required this.columnWidth,
    required this.header,
    required this.info,
  });

  @override
  final AbsFlexibleTableColumnWidth columnWidth;

  final Widget header;
  final Widget Function(int dataIndex, T data) info;

  @override
  Widget buildHeader(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    double parentWidth,
  ) =>
      header;

  @override
  Widget buildInfo(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    double parentWidth,
    int dataIndex,
    T data,
  ) =>
      info.call(dataIndex, data);
}
