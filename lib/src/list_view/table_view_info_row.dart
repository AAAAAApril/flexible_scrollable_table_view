import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/scroll_behavior.dart';
import 'package:flexible_scrollable_table_view/src/widgets/table_column_info_widget.dart';
import 'package:flutter/widgets.dart';

///表信息行
class TableViewInfoRow<T> extends StatelessWidget {
  const TableViewInfoRow(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    required this.dataIndex,
    required this.data,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final int dataIndex;
  final T data;

  @override
  Widget build(BuildContext context) {
    final double height = columnConfigurations.fixedInfoRowHeight(context, data);
    Widget child;
    if (columnConfigurations.pinnedColumns.isNotEmpty && columnConfigurations.scrollableColumns.isNotEmpty) {
      child = Row(children: [
        PinnedTableInfoRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
          dataIndex: dataIndex,
          data: data,
          height: height,
        ),
        Expanded(
          child: ScrollableTableInfoRow<T>(
            controller,
            columnConfigurations: columnConfigurations,
            dataIndex: dataIndex,
            data: data,
            height: height,
          ),
        ),
      ]);
    } else {
      if (columnConfigurations.pinnedColumns.isEmpty) {
        child = ScrollableTableInfoRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
          dataIndex: dataIndex,
          data: data,
          height: height,
        );
      } else {
        child = PinnedTableInfoRow<T>(
          controller,
          columnConfigurations: columnConfigurations,
          dataIndex: dataIndex,
          data: data,
          height: height,
        );
      }
    }
    return child;
  }
}

///表信息行固定区域
class PinnedTableInfoRow<T> extends StatelessWidget {
  const PinnedTableInfoRow(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    required this.dataIndex,
    required this.data,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final int dataIndex;
  final T data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columnConfigurations.pinnedColumns
          .map<Widget>(
            (e) => TableColumnInfoWidget<T>(
              controller,
              dataIndex: dataIndex,
              data: data,
              column: e,
              height: height,
            ),
          )
          .toList(growable: false),
    );
  }
}

///表信息行滚动区域
class ScrollableTableInfoRow<T> extends StatelessWidget {
  const ScrollableTableInfoRow(
    this.controller, {
    super.key,
    required this.columnConfigurations,
    required this.dataIndex,
    required this.data,
    required this.height,
  });

  final FlexibleTableController<T> controller;
  final FlexibleColumnConfigurations<T> columnConfigurations;
  final int dataIndex;
  final T data;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, p1) {
        Widget child = ScrollableTabInfoRowWrapper<T>(
          controller,
          columns: columnConfigurations.scrollableColumns.toList(),
          dataIndex: dataIndex,
          data: data,
          height: height,
        );
        if (controller.noHorizontalScrollBehavior) {
          child = ScrollConfiguration(
            behavior: const NoOverscrollScrollBehavior(),
            child: child,
          );
        }
        return SizedBox.fromSize(
          size: Size(p1.maxWidth, height),
          child: child,
        );
      },
    );
  }
}

class ScrollableTabInfoRowWrapper<T> extends StatefulWidget {
  const ScrollableTabInfoRowWrapper(
    this.controller, {
    Key? key,
    required this.columns,
    required this.dataIndex,
    required this.data,
    required this.height,
  }) : super(key: key);

  final List<FlexibleColumn<T>> columns;
  final FlexibleTableController<T> controller;
  final int dataIndex;
  final T data;
  final double height;

  @override
  State<ScrollableTabInfoRowWrapper> createState() => _ScrollableTabInfoRowWrapperState();
}

class _ScrollableTabInfoRowWrapperState extends State<ScrollableTabInfoRowWrapper> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant ScrollableTabInfoRowWrapper oldWidget) {
    if (oldWidget.data != widget.data) {
      unInit();
      init();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    unInit();
    super.dispose();
  }

  void init() {
    scrollController = ScrollController(
      initialScrollOffset: widget.controller.headerRowScrollController.offset,
    );
    widget.controller.headerRowScrollController.addListener(onHeaderScrollChanged);
    scrollController.addListener(onSelfScrollChanged);
  }

  void unInit() {
    scrollController.removeListener(onSelfScrollChanged);
    widget.controller.headerRowScrollController.removeListener(onHeaderScrollChanged);
    scrollController.dispose();
  }

  void onHeaderScrollChanged() {
    if (scrollController.hasClients && widget.controller.headerRowScrollController.offset != scrollController.offset) {
      scrollController.jumpTo(widget.controller.headerRowScrollController.offset);
    }
  }

  void onSelfScrollChanged() {
    if (widget.controller.headerRowScrollController.hasClients &&
        widget.controller.headerRowScrollController.offset != scrollController.offset) {
      widget.controller.headerRowScrollController.jumpTo(scrollController.offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.columns.length,
      scrollDirection: Axis.horizontal,
      primary: false,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => TableColumnInfoWidget(
        widget.controller,
        dataIndex: widget.dataIndex,
        data: widget.data,
        column: widget.columns[index],
        height: widget.height,
      ),
    );
  }
}
