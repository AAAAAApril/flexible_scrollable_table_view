import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flutter/widgets.dart';

///可选列 列头 包装组件
class SelectableColumnHeader<T> extends StatefulWidget {
  const SelectableColumnHeader(
    this.dataSource, {
    super.key,
    required this.builder,
    this.child,
  });

  final FlexibleTableDataSource<T> dataSource;
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
    widget.dataSource.addListener(onValueChanged);
    widget.dataSource.selectedValue.addListener(onValueChanged);
    onValueChanged();
  }

  @override
  void dispose() {
    widget.dataSource.selectedValue.removeListener(onValueChanged);
    widget.dataSource.removeListener(onValueChanged);
    selected.dispose();
    super.dispose();
  }

  void onValueChanged() {
    selected.value = widget.dataSource.selectedValue.value.length >= widget.dataSource.selectableValue.length;
  }

  void onSelectedValueChanged(bool? newValue) {
    if (newValue == null || selected.value == newValue) {
      return;
    }
    //选中全部
    if (newValue) {
      widget.dataSource.selectAllRows();
    }
    //取消选中全部
    else {
      widget.dataSource.unselectAllRows();
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
    this.dataSource, {
    super.key,
    required this.data,
    required this.builder,
    this.child,
  });

  final FlexibleTableDataSource<T> dataSource;
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
    widget.dataSource.selectedValue.addListener(onValueChanged);
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
    widget.dataSource.selectedValue.removeListener(onValueChanged);
    selected.dispose();
    super.dispose();
  }

  void onValueChanged() {
    selected.value = widget.dataSource.isRowSelected(widget.data);
  }

  void onSelectedValueChanged(bool? newValue) {
    if (newValue == null || selected.value == newValue) {
      return;
    }
    //选中当前行
    if (newValue) {
      widget.dataSource.selectRow(widget.data);
    }
    //取消选中当前行
    else {
      widget.dataSource.unselectRow(widget.data);
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
