import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///可选列 列信息 包装组件
class SelectableColumnInfo<T> extends StatefulWidget {
  const SelectableColumnInfo(
    this.controller, {
    super.key,
    required this.data,
    required this.builder,
  });

  final FlexibleTableController<T> controller;
  final T data;
  final Widget Function(
    BuildContext context,
    bool selected,
    ValueChanged<bool?> onChanged,
  ) builder;

  @override
  State<SelectableColumnInfo<T>> createState() => _SelectableColumnInfoState<T>();
}

class _SelectableColumnInfoState<T> extends State<SelectableColumnInfo<T>> {
  late ValueNotifier<bool> selected;

  @override
  void initState() {
    super.initState();
    selected = ValueNotifier<bool>(false);
    widget.controller.selectedValue.addListener(onValueChanged);
    onValueChanged();
  }

  @override
  void didUpdateWidget(covariant SelectableColumnInfo<T> oldWidget) {
    if (oldWidget.data != widget.data) {
      onValueChanged();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.selectedValue.removeListener(onValueChanged);
    selected.dispose();
    super.dispose();
  }

  void onValueChanged() {
    selected.value = widget.controller.isRowSelected(widget.data);
  }

  void onSelectedValueChanged(bool? newValue) {
    if (newValue == null || selected.value == newValue) {
      return;
    }
    //选中当前行
    if (newValue) {
      widget.controller.selectRow(widget.data);
    }
    //取消选中当前行
    else {
      widget.controller.unselectRow(widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: selected,
      builder: (context, value, child) => widget.builder.call(
        context,
        value,
        onSelectedValueChanged,
      ),
    );
  }
}
