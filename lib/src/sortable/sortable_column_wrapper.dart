import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/sortable/sortable_column_mixin.dart';
import 'package:flutter/widgets.dart';

///可排序列包装
class SortableColumnWrapper<T> extends StatefulWidget {
  const SortableColumnWrapper(
    this.controller, {
    Key? key,
    required this.currentColumn,
    required this.builder,
    this.child,
  }) : super(key: key);

  final FlexibleTableController<T> controller;
  final AbsFlexibleColumn<T> currentColumn;
  final Widget Function(
    BuildContext context,
    bool currentColumnSorting,
    FlexibleColumnSortType sortingType,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  State<SortableColumnWrapper<T>> createState() => _SortableColumnWrapperState<T>();
}

class _SortableColumnWrapperState<T> extends State<SortableColumnWrapper<T>> {
  late bool currentSorting;

  late FlexibleColumnSortType sortingType;

  @override
  void initState() {
    super.initState();
    currentSorting = widget.controller.sortingColumn.value == widget.currentColumn;
    sortingType = widget.controller.sortingType.value;
    widget.controller.sortingColumn.addListener(onSortingChanged);
    widget.controller.sortingType.addListener(onSortingChanged);
  }

  @override
  void didUpdateWidget(covariant SortableColumnWrapper<T> oldWidget) {
    if (oldWidget.currentColumn != widget.currentColumn) {
      currentSorting = widget.controller.sortingColumn.value == widget.currentColumn;
      sortingType = widget.controller.sortingType.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.sortingColumn.removeListener(onSortingChanged);
    widget.controller.sortingType.removeListener(onSortingChanged);
    super.dispose();
  }

  void onSortingChanged() {
    final FlexibleColumnSortType newType = widget.controller.sortingType.value;
    final bool newSorting = widget.controller.sortingColumn.value == widget.currentColumn;
    if (newSorting != currentSorting || newType != sortingType) {
      currentSorting = newSorting;
      sortingType = newType;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, currentSorting, sortingType, widget.child);
  }
}
