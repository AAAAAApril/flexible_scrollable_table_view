import 'dart:math';

import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Widget> pages = <String, Widget>{
      '普通列表': const NormalList(),
      'Sliver内': const InSliverList(),
    };
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('双向滚动TableView'),
        ),
        body: DefaultTabController(
          length: pages.length,
          child: Column(
            children: [
              TabBar(tabs: pages.keys.map<Widget>((e) => Tab(text: e)).toList()),
              Expanded(
                child: TabBarView(
                  children: pages.values.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///普通列
class NormalColumn<T> extends AbsFlexibleColumn<T> {
  const NormalColumn(
    super.id, {
    required this.fixedWidth,
    required this.headerText,
    required this.infoText,
    this.onHeaderPressed,
    this.onInfoPressed,
    this.comparator,
  });

  final String headerText;
  final String Function(T data) infoText;
  final VoidCallback? onHeaderPressed;
  final ValueChanged<T>? onInfoPressed;
  @override
  final double fixedWidth;

  @override
  final Comparator<T>? comparator;

  @override
  Widget buildHeader(FlexibleTableController<T> controller) {
    Widget child = SizedBox.expand(
      child: Center(
        child: Text(headerText),
      ),
    );
    if (onHeaderPressed != null || comparableColumn) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onHeaderPressed?.call();
          controller.sortByColumn(this);
        },
        child: child,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.grey,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget buildInfo(FlexibleTableController<T> controller, int dataIndex, T data) {
    Widget child = SizedBox.expand(
      child: Center(
        child: Text(infoText.call(data)),
      ),
    );
    if (onInfoPressed != null) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onInfoPressed?.call(data),
        child: child,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.blue,
        ),
      ),
      child: child,
    );
  }
}

///可选择列
class CustomSelectableColumn<T> extends AbsSelectableColumn<T> {
  const CustomSelectableColumn(
    super.id, {
    required this.selectableWidth,
    this.unSelectableWidth = 0,
  });

  @override
  final double selectableWidth;

  @override
  final double unSelectableWidth;

  @override
  Widget buildSelectableHeader(FlexibleTableController<T> controller) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
      ),
      child: SelectableColumnHeader<T>(
        controller,
        builder: (context, selected, onChanged, child) => Checkbox(
          value: selected,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget buildUnSelectableHeader(FlexibleTableController<T> controller) {
    return const SizedBox.expand(
      child: ColoredBox(color: Colors.purple),
    );
  }

  @override
  Widget buildSelectableInfo(FlexibleTableController<T> controller, int dataIndex, T data) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.red,
        ),
      ),
      child: SelectableColumnInfo<T>(
        controller,
        data: data,
        builder: (context, selected, onChanged, child) => Checkbox(
          value: selected,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget buildUnSelectableInfo(FlexibleTableController<T> controller, int dataIndex, T data) {
    return SizedBox.expand(
      child: ColoredBox(color: dataIndex.isOdd ? Colors.red : Colors.yellow),
    );
  }
}

class NormalList extends StatefulWidget {
  const NormalList({Key? key}) : super(key: key);

  @override
  State<NormalList> createState() => _NormalListState();
}

class _NormalListState extends State<NormalList> {
  late FlexibleTableController<TableDataBean> controller;
  final AbsFlexibleTableAnimations animations = const FlexibleTableAnimations(
    duration: Duration(seconds: 2),
  );

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
      random.nextInt(40) + 30,
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
    final AbsFlexibleTableConfigurations<TableDataBean> configurations = FlexibleTableConfigurations<TableDataBean>(
      headerRowHeight: 40,
      // headerRowHeight: 60,
      infoRowHeight: 50,
      infoRowHeightBuilder: (context, dataIndex, data) {
        return dataIndex == 9
            ?
            80
            // 50
            : null;
      },
      pinnedColumns: {
        NormalColumn(
          'title',
          fixedWidth: 130,
          headerText: 'title列',
          infoText: (data) => data.title,
          onHeaderPressed: () {
            debugPrint('点击了title列头');
          },
        ),
        const CustomSelectableColumn(
          'selectable',
          selectableWidth: 48,
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
          child: FlexibleTableHeader<TableDataBean>(
            controller,
            configurations: configurations,
            animations: animations,
          ),
        ),
        Expanded(
          child: FlexibleTableContent<TableDataBean>(
            controller,
            configurations: configurations,
            animations: animations,
            decorations: FlexibleTableDecorations(
              backgroundRow: (dataIndex, data) => ColoredBox(
                color: dataIndex.isOdd ? Colors.grey.shade200 : Colors.grey.shade300,
                child: const SizedBox.expand(),
              ),
              foregroundRow: (dataIndex, data) => GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  debugPrint('点击了前景装饰行:$dataIndex');
                },
              ),
            ),
            headerFooter: FlexibleHeaderFooter(
              fixedHeaderHeight: configurations.infoRowHeight,
              header: OutlinedButton(
                onPressed: () {
                  debugPrint('点击了列表的Header');
                },
                child: const Text('这里是列表的Header，一个OutlinedButton'),
              ),
              fixedFooterHeight: configurations.infoRowHeight,
              footer: OutlinedButton(
                onPressed: () {
                  debugPrint('点击了列表的Footer');
                },
                child: const Text('这里是列表的Footer，一个OutlinedButton'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class InSliverList extends StatefulWidget {
  const InSliverList({Key? key}) : super(key: key);

  @override
  State<InSliverList> createState() => _InSliverListState();
}

class _InSliverListState extends State<InSliverList> {
  late FlexibleTableController<TableDataBean> controller;
  late AbsFlexibleTableConfigurations<TableDataBean> configurations;

  @override
  void initState() {
    super.initState();
    controller = FlexibleTableController<TableDataBean>();
    configurations = FlexibleTableConfigurations<TableDataBean>(
      infoRowHeight: 50,
      pinnedColumns: {
        NormalColumn(
          'title',
          fixedWidth: 130,
          headerText: 'title列',
          infoText: (data) => data.title,
          onHeaderPressed: () {
            debugPrint('点击了title列头');
          },
        ),
      },
      scrollableColumns: {
        NormalColumn(
          'value1',
          fixedWidth: 150,
          headerText: 'value1列',
          infoText: (data) => data.value1,
        ),
        const CustomSelectableColumn(
          'selectable',
          selectableWidth: 48,
          unSelectableWidth: 32,
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
      random.nextInt(20) + 10,
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
        SliverToBoxAdapter(
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
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: FlexibleTableContent<TableDataBean>.sliver(
            controller,
            configurations: configurations,
            decorations: FlexibleTableDecorations(
              backgroundRow: (dataIndex, data) => ColoredBox(
                color: dataIndex.isOdd ? Colors.grey.shade100 : Colors.grey.shade200,
                child: const SizedBox.expand(),
              ),
            ),
            headerFooter: FlexibleHeaderFooter(
              fixedHeaderHeight: configurations.infoRowHeight,
              header: ElevatedButton(
                onPressed: () {
                  debugPrint('点击了Header');
                },
                child: const Text('这里是Header，一个ElevatedButton'),
              ),
              // fixedFooterHeight: configurations.infoRowHeight,
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('点击了Footer');
                    },
                    child: const Text('这里是Footer，一个ElevatedButton'),
                  ),
                  const ColoredBox(
                    color: Colors.yellow,
                    child: SizedBox.square(
                      dimension: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///数据实体
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
