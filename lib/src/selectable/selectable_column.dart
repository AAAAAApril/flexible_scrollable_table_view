import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
abstract class SelectableColumn<T> extends FlexibleColumn<T> {
  const SelectableColumn(
    super.id, {
    required super.fixedWidth,
    this.unSelectableWidth = 0,
    super.comparator,
  });

  ///非可选状态时的固定宽度
  final double unSelectableWidth;

  @override
  Widget buildHeader(
    FlexibleTableController<T> controller,
    BuildContext context,
    Size fixedSize,
  ) =>
      buildSelectableHeader(
        controller,
        context,
        fixedSize,
      );

  ///构建可编辑时的表头
  @protected
  Widget buildSelectableHeader(
    FlexibleTableController<T> controller,
    BuildContext context,
    //可编辑时的表头大小
    Size selectableFixedSize,
  );

  ///构建不可编辑时的表头
  Widget buildUnSelectableHeader(
    FlexibleTableController<T> controller,
    BuildContext context,
    //不可编辑时的表头大小
    Size unSelectableFixedSize,
  ) =>
      const SizedBox.shrink();

  @override
  Widget buildInfo(
    FlexibleTableController<T> controller,
    BuildContext context,
    Size fixedSize,
    int dataIndex,
    T data,
  ) =>
      buildSelectableInfo(
        controller,
        context,
        fixedSize,
        dataIndex,
        data,
      );

  ///构建可编辑时的表信息
  @protected
  Widget buildSelectableInfo(
    FlexibleTableController<T> controller,
    BuildContext context,
    //可编辑时的信息大小
    Size selectableFixedSize,
    int dataIndex,
    T data,
  );

  ///构建不可编辑时的表信息
  Widget buildUnSelectableInfo(
    FlexibleTableController<T> controller,
    BuildContext context,
    //不可编辑时的信息大小
    Size unSelectableFixedSize,
    int dataIndex,
    T data,
  ) =>
      const SizedBox.shrink();
}
