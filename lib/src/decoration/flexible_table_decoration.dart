import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表行装饰
abstract class AbsFlexibleTableRowDecoration<T> {
  const AbsFlexibleTableRowDecoration();

  ///构建装饰
  Widget buildRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  );
}

class FlexibleTableRowDecoration<T> extends AbsFlexibleTableRowDecoration<T> {
  const FlexibleTableRowDecoration({
    required this.builder,
  }) : super();

  final Widget Function(int dataIndex, T data) builder;

  @override
  Widget buildRowDecoration(
    FlexibleTableController<T> controller,
    AbsFlexibleTableConfigurations<T> configurations,
    int dataIndex,
    T data,
  ) =>
      builder.call(dataIndex, data);
}
