import 'dart:async';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TableHorizontalScrollMixin {
  late FlexibleTableDataSource<StudentBean> dataSource;
  late FlexibleTableRowBuilderMixin<StudentBean> rowBuilder;

  late SynchronizedScrollMixin scrollMixin;

  late AdaptedGroup group;

  late ValueNotifier<String> randomName;

  @override
  void initState() {
    super.initState();
    dataSource = FlexibleTableDataSource();
    scrollMixin = SynchronizedScrollController();

    group = AdaptedGroup();
    randomName = ValueNotifier<String>('');

    rowBuilder = DefaultRowBuilder(
      this,
      leftPinnedColumns: {
        const StudentIdColumn()
            //设置列宽为固定宽度
            .appointWidth(const FixedWidth(100)),
      },
      scrollableColumns: {
        StudentNameColumn(
          randomName: randomName,
        )
            //设置列的宽度根据其内容自动变化
            .appointWidth(AdaptedWidth<StudentBean>(group)),
        const StudentAgeColumn()
            //给列头添加点击排序的功能
            .withSortByPressColumnHeader((column, a, b) => a.age.compareTo(b.age))
            //设置列宽为父容器宽度的 0.5 倍
            .appointWidth(ProportionalWidth(0.5)),
        const StudentGenderColumn()
            //给列信息项添加点击事件
            .whenInfoClicked((column, arguments, context) {
          debugPrint('点击了[${column.id}]列的第[${arguments.dataIndex}]项的数据[${arguments.data.gender}]');
        }).appointWidth(const FixedWidth(60)),
      },
    )
        //给行设置固定的高度
        .appointHeight(const FixedHeight(headerHeight: 48, infoHeight: 150))
        //给行设置装饰
        .withDecoration(
      infoRowDecoration: (arguments) {
        return BoxDecoration(
          color: arguments.dataIndex.isEven ? Colors.blue.shade50 : Colors.blue.shade100,
        );
      },
    );
    refreshName();
    refreshData();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    randomName.dispose();
    group.dispose();
    scrollMixin.dispose();
  }

  late Timer timer;

  void refreshName() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      randomName.value = randomNames.first;
    });
  }

  @override
  ScrollController createScrollController() {
    return scrollMixin;
  }

  @override
  void destroyScrollController(ScrollController controller) {}

  void refreshData() {
    final Random random = Random.secure();
    final List<String> names = List.of(randomNames);
    dataSource.value = names
        .map<StudentBean>(
          (e) => StudentBean(
            id: int.parse(e.hashCode.toString().substring(0, 3)),
            name: e,
            age: random.nextInt(3) + 12,
            gender: random.nextBool() ? '男' : '女',
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(children: [
        Material(
          elevation: 4,
          color: Colors.white,
          child: FlexibleTableHeader<StudentBean>(dataSource, rowBuilder: rowBuilder),
        ),
        Expanded(
          child: FlexibleTableContent<StudentBean>(dataSource, rowBuilder: rowBuilder),
        ),
      ]),
    );
  }
}

class StudentIdColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentIdColumn() : super('学号');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(id.toString()),
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<StudentBean> arguments) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        arguments.data.id.toString(),
      ),
    );
  }
}

class StudentNameColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentNameColumn({
    required this.randomName,
  }) : super('姓名');

  final ValueNotifier<String> randomName;

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Center(child: Text(id.toString()));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<StudentBean> arguments) {
    final Widget child;
    if (arguments.dataIndex == 3) {
      //将3号下标的内容替换为会变化的文字
      child = ValueListenableBuilder<String>(
        valueListenable: randomName,
        builder: (context, value, child) => Text(value),
      );
    } else {
      child = Text(
        arguments.data.name,
      );
    }
    return ColoredBox(
      color: arguments.dataIndex.isOdd ? Colors.pinkAccent : Colors.purple,
      child: Align(
        alignment: Alignment.centerRight,
        child: child,
      ),
    );
  }
}

class StudentAgeColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentAgeColumn() : super('年龄');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Center(child: Text(id.toString()));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<StudentBean> arguments) {
    return Center(
      child: Text(
        arguments.data.age.toString(),
      ),
    );
  }
}

class StudentGenderColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentGenderColumn() : super('性别');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Center(child: Text(id.toString()));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<StudentBean> arguments) {
    return Center(
      child: Text(
        arguments.data.gender,
      ),
    );
  }
}

class StudentBean {
  const StudentBean({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });

  final int id;
  final String name;
  final int age;
  final String gender;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentBean &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          age == other.age &&
          gender == other.gender;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ age.hashCode ^ gender.hashCode;
}

List<String> get randomNames => [
      'Zelda',
      'Sebastian',
      'Trista',
      'Holy',
      'Joyce',
      'Kirstyn',
      'Dale',
      'Walter',
      'Immortal',
      'Garret',
      'Jillian',
      'Timothea',
      'Quinlan',
      'Philomena',
      'Logan',
      'Fairy',
      'Gazelle',
      'Lorelei',
      'Haley',
      'Miriam',
      'Ian',
      'Beautiful',
      'Audrey',
      'Harmony',
      'Quintana',
      'Russell',
      'Patience',
      'Edric',
      'Rosalind',
      'Serpent',
    ]..shuffle();
