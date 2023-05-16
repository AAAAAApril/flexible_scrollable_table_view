import 'dart:math';

import 'package:example/columns/normal_column.dart';
import 'package:example/columns/selectable_column.dart';
import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

class NormalList extends StatefulWidget {
  const NormalList({Key? key}) : super(key: key);

  @override
  State<NormalList> createState() => _NormalListState();
}

class _NormalListState extends State<NormalList> {
  late FlexibleTableController<TableDataBean> controller;

  @override
  void initState() {
    super.initState();
    controller = FlexibleTableController<TableDataBean>()
      // ..noHorizontalScrollBehavior = true
      // ..noVerticalScrollBehavior = true
    ;
    refreshData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void refreshData() {
    final Random random = Random.secure();
    controller.value = List<TableDataBean>.generate(
      random.nextInt(20) + 20,
      (index) => TableDataBean(
        id: index,
        title: '数据标题$index',
        value1: 'String值$index',
        value2: random.nextInt(1000),
        value3: random.nextDouble() * 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FlexibleColumnConfigurations<TableDataBean> columnConfigurations = FlexibleColumnConfigurations(
      headerRowHeight: 40,
      infoRowHeight: 50,
      pinnedColumns: {
        NormalColumn(
          'title',
          fixedWidth: 120,
          headerText: 'title列',
          infoText: (data) => data.title,
          onHeaderPressed: () {
            debugPrint('点击了title列头');
          },
        ),
        const CustomSelectableColumn(
          'selectable',
          fixedWidth: 48,
          unSelectableWidth: 32,
        ),
      },
      scrollableColumns: {
        NormalColumn(
          'value1',
          fixedWidth: 150,
          headerText: 'value1列',
          infoText: (data) => data.value1,
        ),
        NormalColumn(
          'value2',
          fixedWidth: 100,
          headerText: 'value2列',
          infoText: (data) => data.value2.toString(),
          comparator: (a, b) => a.value2.compareTo(b.value2),
          onInfoPressed: (data) {
            debugPrint('点击了value2列信息：${data.value2}');
          },
        ),
        NormalColumn(
          'value3',
          fixedWidth: 130,
          headerText: 'value3列',
          infoText: (data) => data.value3.toStringAsFixed(4),
          comparator: (a, b) => a.value3.compareTo(b.value3),
          onHeaderPressed: () {
            debugPrint('点击了value3列头');
          },
        ),
      },
    );
    return Column(
      children: [
        Row(children: [
          IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.selectable,
              builder: (context, value, child) => CheckboxListTile(
                value: value,
                title: const Text('切换可选与不可选状态'),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.switchSelectable(newValue);
                  }
                },
              ),
            ),
          ),
        ]),
        Material(
          elevation: 2,
          // child: TableViewHeader(
          //   controller,
          //   columnConfigurations: columnConfigurations,
          // ),
          child: TableViewHeaderRow<TableDataBean>(
            controller,
            columnConfigurations: columnConfigurations,
          ),
        ),
        Expanded(
          // child: ScrollConfiguration(
          //   behavior: const NoOverscrollScrollBehavior(),
          //   child: SingleChildScrollView(
          //     child: Stack(children: [
          //       ///背景装饰
          //       FlexibleTableContentDecoration(
          //         controller,
          //         columnConfigurations: columnConfigurations,
          //         rowDecorationBuilder: (context, fixedHeight, dataIndex, data) => ColoredBox(
          //           color: dataIndex.isOdd ? Colors.grey.shade300 : Colors.grey.shade400,
          //           child: const SizedBox.expand(),
          //         ),
          //       ),
          //
          //       ///表内容
          //       TableViewContent(
          //         controller,
          //         columnConfigurations: columnConfigurations,
          //       ),
          //
          //       ///前景装饰
          //       FlexibleTableContentDecoration(
          //         controller,
          //         columnConfigurations: columnConfigurations,
          //         rowDecorationBuilder: (context, fixedHeight, dataIndex, data) => ValueListenableBuilder<bool>(
          //           valueListenable: controller.selectable,
          //           builder: (context, selectable, child) => GestureDetector(
          //             behavior: selectable ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
          //             onTap: () {
          //               debugPrint('>>>>>>>>>>> 点击了表的前景装饰行 $dataIndex');
          //             },
          //           ),
          //         ),
          //       ),
          //     ]),
          //   ),
          // ),
          child: TableViewContentArea<TableDataBean>(
            controller,
            columnConfigurations: columnConfigurations,
          ),
        ),
      ],
    );
  }
}

class TableDataBean {
  const TableDataBean({
    required this.id,
    required this.title,
    required this.value1,
    required this.value2,
    required this.value3,
  });

  final int id;
  final String title;
  final String value1;
  final int value2;
  final double value3;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TableDataBean && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
