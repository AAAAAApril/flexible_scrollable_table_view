import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///可排序 Column
abstract class AbsSortableColumn<T> extends AbsFlexibleColumn<T> {
  const AbsSortableColumn(super.id);

  @override
  Comparator<T> get comparator;
}

class SortableColumn<T> extends AbsSortableColumn<T> {
  const SortableColumn(
    super.id, {
    required this.fixedWidth,
    required this.comparator,
    required this.header,
    required this.info,
  });

  @override
  final double fixedWidth;
  @override
  final Comparator<T> comparator;

  final Widget header;
  final Widget Function(int dataIndex, T data) info;

  @override
  Widget buildHeader(FlexibleTableController<T> controller) => header;

  @override
  Widget buildInfo(FlexibleTableController<T> controller, int dataIndex, T data) => info.call(dataIndex, data);
}
