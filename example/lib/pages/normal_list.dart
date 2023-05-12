import 'dart:math';

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
    controller = FlexibleTableController<TableDataBean>();
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
      random.nextInt(20),
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
    final FlexibleColumn<TableDataBean> id = FlexibleColumn(
      'id',
      fixedWidth: 30,
      nameBuilder: (context, fixedSize) => const Text('id列'),
      infoBuilder: (context, data, fixedSize) => Text(data.id.toString()),
    );
    final FlexibleColumn<TableDataBean> title = FlexibleColumn(
      'title',
      fixedWidth: 50,
      nameBuilder: (context, fixedSize) => const Text('title列'),
      infoBuilder: (context, data, fixedSize) => Text(data.title),
    );
    final FlexibleColumn<TableDataBean> value1 = FlexibleColumn(
      'value1',
      fixedWidth: 100,
      nameBuilder: (context, fixedSize) => const Text('value1列'),
      infoBuilder: (context, data, fixedSize) => Text(data.value1),
    );
    final FlexibleColumn<TableDataBean> value2 = FlexibleColumn(
      'value2',
      fixedWidth: 50,
      nameBuilder: (context, fixedSize) => const Text('value2列'),
      infoBuilder: (context, data, fixedSize) => Text(data.value2.toString()),
    );
    final FlexibleColumn<TableDataBean> value3 = FlexibleColumn(
      'value3',
      fixedWidth: 80,
      nameBuilder: (context, fixedSize) => const Text('value3列'),
      infoBuilder: (context, data, fixedSize) => Text(data.value3.toStringAsFixed(4)),
    );
    return FlexibleScrollableTableView<TableDataBean>(
      controller: controller,
      nameRowHeight: 60,
      infoRowHeight: 50,
      pinnedColumns: {
        id,
      },
      scrollableColumns: {
        title,
        value1,
        value2,
        value3,
      },
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
