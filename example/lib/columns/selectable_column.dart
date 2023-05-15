import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

///可选择列
class CustomSelectableColumn<T> extends SelectableColumn<T> {
  const CustomSelectableColumn(
    super.id, {
    required super.fixedWidth,
    super.unSelectableWidth,
  });

  @override
  Widget buildSelectableHeader(FlexibleTableController<T> controller, BuildContext context, Size selectableFixedSize) {
    return SelectableColumnHeader<T>(
      controller,
      builder: (context, selected, onChanged, child) => Checkbox(
        value: selected,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget buildUnSelectableHeader(
      FlexibleTableController<T> controller, BuildContext context, Size unSelectableFixedSize) {
    return SizedBox.fromSize(
      size: unSelectableFixedSize,
      child: const ColoredBox(color: Colors.purple),
    );
  }

  @override
  Widget buildSelectableInfo(
      FlexibleTableController<T> controller, BuildContext context, Size selectableFixedSize, int dataIndex, T data) {
    return SelectableColumnInfo<T>(
      controller,
      data: data,
      builder: (context, selected, onChanged, child) => Checkbox(
        value: selected,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget buildUnSelectableInfo(
      FlexibleTableController<T> controller, BuildContext context, Size unSelectableFixedSize, int dataIndex, T data) {
    return SizedBox.fromSize(
      size: unSelectableFixedSize,
      child: const ColoredBox(color: Colors.red),
    );
  }
}
