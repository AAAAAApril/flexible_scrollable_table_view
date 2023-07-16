import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///可选列 列头 包装组件
class SelectableColumnHeader<T> extends StatefulWidget {
  const SelectableColumnHeader(
    this.controller, {
    super.key,
    required this.builder,
    this.child,
  });

  final FlexibleTableController<T> controller;
  final Widget Function(
    BuildContext context,
    bool selected,
    ValueChanged<bool?> onChanged,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  State<SelectableColumnHeader<T>> createState() => _SelectableColumnHeaderState<T>();
}

class _SelectableColumnHeaderState<T> extends State<SelectableColumnHeader<T>> {
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
        widget.child,
      ),
    );
  }
}

///可选列 列信息 包装组件
class SelectableColumnInfo<T> extends StatefulWidget {
  const SelectableColumnInfo(
    this.controller, {
    super.key,
    required this.data,
    required this.builder,
    this.child,
  });

  final FlexibleTableController<T> controller;
  final T data;
  final Widget Function(
    BuildContext context,
    bool selected,
    ValueChanged<bool?> onChanged,
    Widget? child,
  ) builder;
  final Widget? child;

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
        widget.child,
      ),
    );
  }
}
