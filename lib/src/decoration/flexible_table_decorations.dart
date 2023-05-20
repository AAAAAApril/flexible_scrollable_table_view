import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表装饰配置
abstract class AbsFlexibleTableDecorations<T> {
  const AbsFlexibleTableDecorations();

  ///构建表行前景装饰
  Widget? buildForegroundRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  );

  ///构建表行背景装饰
  Widget? buildBackgroundRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  );
}

class FlexibleTableDecorations<T> extends AbsFlexibleTableDecorations<T> {
  const FlexibleTableDecorations({
    this.foregroundRow,
    this.backgroundRow,
  });

  final Widget Function(int dataIndex, T data)? foregroundRow;
  final Widget Function(int dataIndex, T data)? backgroundRow;

  @override
  Widget? buildBackgroundRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  ) =>
      backgroundRow?.call(dataIndex, data);

  @override
  Widget? buildForegroundRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  ) =>foregroundRow?.call(dataIndex,data);
}
