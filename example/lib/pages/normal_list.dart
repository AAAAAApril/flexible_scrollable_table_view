import 'dart:math';

import 'package:example/widgets/selectable_column_header.dart';
import 'package:example/widgets/selectable_column_info.dart';
import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

class NormalList extends StatefulWidget {
  const NormalList({Key? key}) : super(key: key);

  @override
  State<NormalList> createState() => _NormalListState();
}

class _NormalListState extends State<NormalList> {
  late FlexibleTableController<TableDataBean> controller;
  final FlexibleColumnController<TableDataBean> columnController = FlexibleColumnController<TableDataBean>(
    headerRowHeight: 50,
    infoRowHeight: 60,
  );

  @override
  void initState() {
    super.initState();
    controller = FlexibleTableController<TableDataBean>();
    columnController.addPinnedColumns({
      FlexibleColumn(
        'title',
        fixedWidth: 120,
        headerBuilder: (context, fixedSize) => const Text('title列'),
        infoBuilder: (context, column, fixedSize, dataIndex, data) => Text(data.title),
        onColumnHeaderPressed: (context, column) {
          debugPrint('点击了title列头');
          return true;
        },
      ),
      SelectableColumn(
        'selectable',
        fixedWidth: 48,
        unSelectableWidth: 32,
        headerBuilder: (context, fixedSize) => SelectableColumnHeader(
          controller,
          builder: (context, selected, onChanged) => Checkbox(
            value: selected,
            onChanged: onChanged,
          ),
        ),
        infoBuilder: (context, column, fixedSize, dataIndex, data) => SelectableColumnInfo(
          controller,
          data: data,
          builder: (context, selected, onChanged) => Checkbox(
            value: selected,
            onChanged: onChanged,
          ),
        ),
        unSelectableHeader: (context, fixedSize) => SizedBox.fromSize(
          size: fixedSize,
          child: const ColoredBox(color: Colors.purple),
        ),
        unSelectableInfo: (context, column, fixedSize, dataIndex, data) => SizedBox.fromSize(
          size: fixedSize,
          child: const ColoredBox(color: Colors.red),
        ),
      ),
    });
    columnController.addScrollableColumns({
      FlexibleColumn(
        'value1',
        fixedWidth: 150,
        headerBuilder: (context, fixedSize) => const Text('value1列'),
        infoBuilder: (context, column, fixedSize, dataIndex, data) => Text(data.value1),
      ),
      FlexibleColumn(
        'value2',
        fixedWidth: 100,
        headerBuilder: (context, fixedSize) => const Text('value2列'),
        infoBuilder: (context, column, fixedSize, dataIndex, data) => Text(data.value2.toString()),
        comparator: (a, b) => a.value2.compareTo(b.value2),
        onColumnInfoPressed: (context, column, data) {
          debugPrint('点击了value2列信息：${data.value2}');
        },
      ),
      FlexibleColumn(
        'value3',
        fixedWidth: 130,
        headerBuilder: (context, fixedSize) => const Text('value3列'),
        infoBuilder: (context, column, fixedSize, dataIndex, data) => Text(data.value3.toStringAsFixed(4)),
        comparator: (a, b) => a.value3.compareTo(b.value3),
        onColumnHeaderPressed: (context, column) {
          debugPrint('点击了value3列头');
          return false;
        },
      ),
    });
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
          child: TableViewHeader(
            controller,
            columnController: columnController,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Stack(children: [
              ///背景装饰
              FlexibleTableContentDecoration(
                controller,
                columnController: columnController,
                rowDecorationBuilder: (context, fixedHeight, dataIndex, data) => ColoredBox(
                  color: dataIndex.isOdd ? Colors.grey.shade300 : Colors.grey.shade400,
                  child: const SizedBox.expand(),
                ),
              ),

              ///表内容
              TableViewContent(
                controller,
                columnController: columnController,
              ),

              ///前景装饰
              FlexibleTableContentDecoration(
                controller,
                columnController: columnController,
                rowDecorationBuilder: (context, fixedHeight, dataIndex, data) => ValueListenableBuilder<bool>(
                  valueListenable: controller.selectable,
                  builder: (context, selectable, child) => GestureDetector(
                    behavior: selectable ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
                    onTap: () {
                      debugPrint('>>>>>>>>>>> 点击了表的前景装饰行 $dataIndex');
                    },
                  ),
                ),
              ),
            ]),
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
