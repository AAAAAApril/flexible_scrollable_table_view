import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/sliver/sliver_flexible_table_content.dart';
import 'package:flutter/widgets.dart';

///表内容区域
class FlexibleTableContent<T> extends StatelessWidget {
  const FlexibleTableContent(
    this.dataSource, {
    super.key,
    required this.rowBuilder,
    this.verticalScrollController,
    this.shrinkWrap = false,
    this.primary,
    this.verticalPhysics,
    this.listHeaderBuilder,
    this.listFooterBuilder,
    this.listPlaceholderBuilder,
  });

  factory FlexibleTableContent.sliver(
    FlexibleTableDataSource<T> dataSource, {
    Key? key,
    required FlexibleTableRowBuilder<T> rowBuilder,
    Widget Function(AbsTableBuildArguments<T> arguments)? listHeaderBuilder,
    Widget Function(AbsTableBuildArguments<T> arguments)? listFooterBuilder,
    Widget Function(AbsTableBuildArguments<T> arguments)? listPlaceholderBuilder,
  }) =>
      SliverFlexibleTableContent<T>(
        dataSource,
        key: key,
        rowBuilder: rowBuilder,
        listHeaderBuilder: listHeaderBuilder,
        listFooterBuilder: listFooterBuilder,
        listPlaceholderBuilder: listPlaceholderBuilder,
      );

  final FlexibleTableDataSource<T> dataSource;
  final FlexibleTableRowBuilder<T> rowBuilder;

  final ScrollController? verticalScrollController;
  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? verticalPhysics;

  final Widget Function(AbsTableBuildArguments<T> arguments)? listHeaderBuilder;
  final Widget Function(AbsTableBuildArguments<T> arguments)? listFooterBuilder;
  final Widget Function(AbsTableBuildArguments<T> arguments)? listPlaceholderBuilder;

  @protected
  bool get hasHeader => listHeaderBuilder != null;

  @protected
  bool get hasFooter => listFooterBuilder != null;

  @protected
  bool get hasPlaceholder => listPlaceholderBuilder != null;

  @protected
  int getItemCount(List<T> dataList) {
    //当数据列是空的
    if (dataList.isEmpty) {
      //需要显示占位符，则返回 有 1 条数据，否则为 0 条。
      return hasPlaceholder ? 1 : 0;
    }
    //数据列不为空，数据总条数 = 头 + 数据列 + 尾
    return (hasHeader ? 1 : 0) + dataList.length + (hasFooter ? 1 : 0);
  }

  @protected
  bool isHeaderIndex(int index) {
    //当下标为 0，并且又有头部的时候，则当前下标为头部
    return index == 0 && hasHeader;
  }

  @protected
  bool isFooterIndex(List<T> value, int index) {
    //当下标 = 数据长度 + 头部数量，则当前下标为尾部
    return index == value.length + (hasHeader ? 1 : 0);
  }

  @protected
  int realDataIndex(int index) {
    //真实的数据下标 = 列表下标 - 头部数量
    return index - (hasHeader ? 1 : 0);
  }

  @protected
  Widget buildItem(
    BuildContext context, {
    required AbsTableBuildArguments<T> arguments,
    required List<T> value,
    required int index,
    required int itemCount,
  }) {
    //数据是空的，却又需要构建列表项，说明是需要绘制占位组件
    if (value.isEmpty && hasPlaceholder) {
      return listPlaceholderBuilder!.call(arguments);
    }
    if (isHeaderIndex(index)) {
      return listHeaderBuilder!.call(arguments);
    }
    if (isFooterIndex(value, index)) {
      return listFooterBuilder!.call(arguments);
    }
    return rowBuilder.buildInfoRow(
      arguments.toInfoRowArguments(
        dataIndex: realDataIndex(index),
        dataList: value,
        currentItemIndex: index,
        totalItemCount: itemCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LazyLayoutBuilder(
      builder: (context, constraints) {
        final AbsTableBuildArguments<T> arguments = TableBuildArguments<T>(
          dataSource: dataSource,
          parentWidth: constraints.maxWidth,
        );
        final Widget child = ValueListenableBuilder<List<T>>(
          valueListenable: dataSource,
          builder: (context, value, child) {
            final int totalItemCount = getItemCount(value);
            return ListView.builder(
              controller: verticalScrollController,
              itemCount: totalItemCount,
              shrinkWrap: shrinkWrap,
              primary: primary,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: verticalPhysics,
              itemBuilder: (context, index) => buildItem(
                context,
                arguments: arguments,
                value: value,
                index: index,
                itemCount: totalItemCount,
              ),
            );
          },
        );
        if (shrinkWrap) {
          return SizedBox(width: constraints.maxWidth, child: child);
        }
        return ConstrainedBox(
          constraints: BoxConstraints.tight(
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          child: child,
        );
      },
    );
  }
}
