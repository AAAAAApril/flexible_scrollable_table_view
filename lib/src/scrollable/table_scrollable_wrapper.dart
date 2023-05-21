import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_header_widget.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

class TableHeaderScrollWrapper<T> extends StatefulWidget {
  const TableHeaderScrollWrapper(
    this.controller, {
    super.key,
    required this.columns,
    required this.height,
    this.physics,
  });

  final FlexibleTableController<T> controller;
  final List<AbsFlexibleColumn<T>> columns;
  final ScrollPhysics? physics;
  final double height;

  @override
  State<TableHeaderScrollWrapper<T>> createState() => _TableHeaderScrollWrapperState<T>();
}

class _TableHeaderScrollWrapperState<T> extends State<TableHeaderScrollWrapper<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller.createHorizontalScrollController();
  }

  @override
  void dispose() {
    widget.controller.releaseHorizontalScrollController(scrollController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.columns.length,
      scrollDirection: Axis.horizontal,
      primary: false,
      padding: EdgeInsets.zero,
      physics: widget.physics,
      itemBuilder: (context, index) => TableColumnHeaderWidget<T>(
        widget.controller,
        column: widget.columns[index],
        height: widget.height,
      ),
    );
  }
}

class TableContentRowScrollWrapper<T> extends StatefulWidget {
  TableContentRowScrollWrapper(
    this.controller, {
    Key? key,
    required Set<AbsFlexibleColumn<T>> columns,
    required this.dataIndex,
    required this.data,
    required this.height,
  })  : columns = columns.toList(growable: false),
        super(key: key);

  final FlexibleTableController<T> controller;
  final List<AbsFlexibleColumn<T>> columns;
  final int dataIndex;
  final T data;
  final double height;

  @override
  State<TableContentRowScrollWrapper<T>> createState() => _TableContentRowScrollWrapperState<T>();
}

class _TableContentRowScrollWrapperState<T> extends State<TableContentRowScrollWrapper<T>> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller.createHorizontalScrollController();
  }

  @override
  void didUpdateWidget(covariant TableContentRowScrollWrapper<T> oldWidget) {
    if (oldWidget.data != widget.data) {
      widget.controller.releaseHorizontalScrollController(scrollController);
      scrollController = widget.controller.createHorizontalScrollController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.releaseHorizontalScrollController(scrollController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.columns.length,
      scrollDirection: Axis.horizontal,
      primary: false,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => TableColumnInfoWidget<T>(
        widget.controller,
        dataIndex: widget.dataIndex,
        data: widget.data,
        column: widget.columns[index],
        height: widget.height,
      ),
    );
  }
}
