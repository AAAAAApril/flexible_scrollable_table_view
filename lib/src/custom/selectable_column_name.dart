import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///可选列 列名 包装组件
class SelectableColumnName<T> extends StatefulWidget {
  const SelectableColumnName(
    this.controller, {
    Key? key,
    required this.builder,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final Widget Function(
    BuildContext context,
    bool selected,
    ValueChanged<bool?> onChanged,
  ) builder;

  @override
  State<SelectableColumnName<T>> createState() => _SelectableColumnNameState<T>();
}

class _SelectableColumnNameState<T> extends State<SelectableColumnName<T>> {
  late ValueNotifier<bool> selected;

  @override
  void initState() {
    super.initState();
    selected = ValueNotifier<bool>(false);
    widget.controller.addListener(onValueChanged);
    widget.controller.selectedValue.addListener(onValueChanged);
    onValueChanged();
  }

  @override
  void dispose() {
    widget.controller.selectedValue.removeListener(onValueChanged);
    widget.controller.removeListener(onValueChanged);
    selected.dispose();
    super.dispose();
  }

  void onValueChanged() {
    selected.value = widget.controller.selectedValue.value.length >= widget.controller.selectableValue.length;
  }

  void onSelectedValueChanged(bool? newValue) {
    if (newValue == null || selected.value == newValue) {
      return;
    }
    //选中全部
    if (newValue) {
      widget.controller.selectAllRows();
    }
    //取消选中全部
    else {
      widget.controller.unselectAllRows();
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
