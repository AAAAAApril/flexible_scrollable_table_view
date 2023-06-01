import 'dart:math';

import 'package:example/src/sliver_persistent_header_delegate_impl.dart';
import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AbsFlexibleTableConfigurations<TableDataBean> configurations = FlexibleTableConfigurations<TableDataBean>(
      rowHeight: ChangeableTableRowHeight(
        headerRowHeight: 40,
        // headerRowHeight: 60,
        fixedInfoRowHeight: 50,
        infoRowHeightBuilder: (dataIndex, data) {
          // return dataIndex == 9 ? 80 : null;
          return null;
        },
      ),
      pinnedColumns: {
        NormalColumn(
          'title',
          columnWidth: ProportionalWidth(1 / 3),
          headerText: 'title列',
          infoText: (data) => data.title,
          onHeaderPressed: () {
            debugPrint('点击了title列头');
          },
        ),
        const CustomSelectableColumn(
          'selectable',
          selectableWidth: FixedWidth(48),
          unSelectableWidth: FixedWidth(32),
        ),
      },
      scrollableColumns: {
        NormalColumn(
          'value1',
          columnWidth: const FixedWidth(150),
          headerText: 'value1列',
          infoText: (data) => data.value1,
        ),
        NormalColumn(
          'value2',
          columnWidth: const FixedWidth(100),
          headerText: 'value2列',
          infoText: (data) => data.value2.toString(),
          comparator: (a, b) => a.value2.compareTo(b.value2),
          onInfoPressed: (data) {
            debugPrint('点击了value2列信息：${data.value2}');
          },
        ),
        NormalColumn(
          'value3',
          columnWidth: FlexibleWidth.min(
            fixedWidth: 130,
            widthPercent: 0.3,
          ),
          headerText: 'value3列',
          infoText: (data) => data.value3.toStringAsFixed(4),
          comparator: (a, b) => a.value3.compareTo(b.value3),
          onHeaderPressed: () {
            debugPrint('点击了value3列头');
          },
        ),
        NormalColumn(
          'value1+value2',
          columnWidth: FlexibleWidth.max(
            fixedWidth: 200,
            widthPercent: 0.5,
          ),
          headerText: 'value1+value2列',
          infoText: (data) => '${data.value1}+${data.value2}',
        ),
        NormalColumn(
          'value2+value3',
          columnWidth: const FixedWidth(200),
          headerText: 'value2+value3列',
          infoText: (data) => '${data.value2}+${data.value3}',
        ),
        NormalColumn(
          'value1+value3',
          columnWidth: ProportionalWidth(0.5),
          headerText: 'value1+value3列',
          infoText: (data) => '${data.value1}+${data.value3}',
        ),
        NormalColumn(
          'value1+value2+value3',
          columnWidth: ProportionalWidth(0.6),
          headerText: 'value1+value2+value3列',
          infoText: (data) => '${data.value1}+${data.value2}+${data.value3}',
        ),
      },
    );
    const AbsFlexibleTableAnimations<TableDataBean> animations = FlexibleTableAnimations(
      duration: Duration(seconds: 2),
    );
    final Map<String, Widget> pages = <String, Widget>{
      '普通列表': NormalList(configurations: configurations, animations: animations),
      'Sliver内': InSliverList(configurations: configurations, animations: animations),
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

class NormalList extends StatefulWidget {
  const NormalList({
    Key? key,
    required this.configurations,
    required this.animations,
  }) : super(key: key);

  final AbsFlexibleTableConfigurations<TableDataBean> configurations;
  final AbsFlexibleTableAnimations<TableDataBean> animations;

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
    if (random.nextInt(10) % 3 == 0) {
      controller.value = <TableDataBean>[];
      return;
    }
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
    return ScrollConfiguration(
      behavior: const NoOverscrollMaterialScrollBehavior(
        [AxisDirection.left, AxisDirection.right],
      ),
      child: Column(
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
              configurations: widget.configurations,
              animations: widget.animations,
            ),
          ),
          Expanded(
            child: FlexibleTableContent<TableDataBean>(
              controller,
              configurations: widget.configurations,
              animations: widget.animations,
              decorations: FlexibleTableDecorationsWithData(
                infoBackgroundRowWithData: (dataIndex, data) => ColoredBox(
                  color: dataIndex.isOdd ? Colors.grey.shade200 : Colors.grey.shade300,
                  child: const SizedBox.expand(),
                ),
                infoForegroundRowWithData: (dataIndex, data) => GestureDetector(
                  behavior: HitTestBehavior.deferToChild,
                  onTap: () {
                    debugPrint('点击了前景装饰行:$dataIndex');
                  },
                ),
              ),
              additions: FlexibleTableAdditions(
                fixedHeaderHeight: widget.configurations.rowHeight.fixedInfoRowHeight,
                header: OutlinedButton(
                  onPressed: () {
                    debugPrint('点击了列表的Header');
                  },
                  child: const Text('这里是列表的Header，一个OutlinedButton'),
                ),
                fixedFooterHeight: widget.configurations.rowHeight.fixedInfoRowHeight,
                footer: OutlinedButton(
                  onPressed: () {
                    debugPrint('点击了列表的Footer');
                  },
                  child: const Text('这里是列表的Footer，一个OutlinedButton'),
                ),
                placeholder: Center(
                  child: ColoredBox(
                    color: Colors.black,
                    child: SizedBox.fromSize(
                      size: const Size(300, 500),
                      child: const Text(
                        '这里是Placeholder，一个 300*500 大小的色块',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InSliverList extends StatefulWidget {
  const InSliverList({
    Key? key,
    required this.configurations,
    required this.animations,
  }) : super(key: key);

  final AbsFlexibleTableConfigurations<TableDataBean> configurations;
  final AbsFlexibleTableAnimations<TableDataBean> animations;

  @override
  State<InSliverList> createState() => _InSliverListState();
}

class _InSliverListState extends State<InSliverList> {
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverPersistentHeaderDelegateImpl(
            fixedHeight: widget.configurations.rowHeight.headerRowHeight,
            child: ColoredBox(
              color: Colors.white,
              child: FlexibleTableHeader<TableDataBean>(
                controller,
                configurations: widget.configurations,
              ),
            ),
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
        FlexibleTableContent<TableDataBean>.sliver(
          controller,
          configurations: widget.configurations,
          animations: widget.animations,
          decorations: FlexibleTableDecorationsWithData(
            infoBackgroundRowWithData: (dataIndex, data) => ColoredBox(
              color: dataIndex.isOdd ? Colors.grey.shade100 : Colors.grey.shade200,
              child: const SizedBox.expand(),
            ),
          ),
          additions: FlexibleTableAdditions(
            fixedHeaderHeight: widget.configurations.rowHeight.fixedInfoRowHeight,
            header: ElevatedButton(
              onPressed: () {
                debugPrint('点击了Header');
              },
              child: const Text('这里是Header，一个ElevatedButton'),
            ),
            footer: const ColoredBox(
              color: Colors.yellow,
              child: SizedBox.square(
                dimension: 200,
                child: Text('这里是Footer，一个ColoredBox'),
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

///普通列
class NormalColumn<T> extends AbsFlexibleColumn<T> {
  const NormalColumn(
    super.id, {
    required this.columnWidth,
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
  final AbsFlexibleTableColumnWidth columnWidth;

  @override
  final Comparator<T>? comparator;

  @override
  Widget buildHeader(BuildArguments<T> arguments) {
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
          //点击列头排序
          arguments.controller.sortByColumn(this);
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
  Widget buildInfo(BuildArguments<T> arguments, int dataIndex, T data) {
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
    this.unSelectableWidth = const FixedWidth(0),
  });

  @override
  final AbsFlexibleTableColumnWidth selectableWidth;

  @override
  final AbsFlexibleTableColumnWidth unSelectableWidth;

  @override
  Widget buildSelectableHeader(BuildArguments<T> arguments) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
      ),
      child: SelectableColumnHeader<T>(
        arguments.controller,
        builder: (context, selected, onChanged, child) => Checkbox(
          value: selected,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget buildUnSelectableHeader(BuildArguments<T> arguments) {
    return const SizedBox.expand(
      child: ColoredBox(color: Colors.purple),
    );
  }

  @override
  Widget buildSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.red,
        ),
      ),
      child: SelectableColumnInfo<T>(
        arguments.controller,
        data: data,
        builder: (context, selected, onChanged, child) => Checkbox(
          value: selected,
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget buildUnSelectableInfo(BuildArguments<T> arguments, int dataIndex, T data) {
    return SizedBox.expand(
      child: ColoredBox(color: dataIndex.isOdd ? Colors.red : Colors.yellow),
    );
  }
}

class NoOverscrollMaterialScrollBehavior extends MaterialScrollBehavior with NoOverscrollBehaviorMixin {
  const NoOverscrollMaterialScrollBehavior(this.disallowedDirections);

  @override
  final List<AxisDirection> disallowedDirections;
}
