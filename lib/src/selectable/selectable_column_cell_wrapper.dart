import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flutter/widgets.dart';

class SelectableColumnCellWrapper<T> extends StatelessWidget {
  const SelectableColumnCellWrapper(
    this.controller, {
    super.key,
    required this.unSelectableBuilder,
    required this.selectableWidget,
  });

  final FlexibleTableController<T> controller;
  final WidgetBuilder unSelectableBuilder;
  final Widget selectableWidget;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return child!;
        }
        //当选择不可用时，不显示
        return unSelectableBuilder.call(context);
      },
      child: selectableWidget,
    );
  }
}
