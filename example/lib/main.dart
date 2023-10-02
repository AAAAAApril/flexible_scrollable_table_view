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

  @override
  void initState() {
    super.initState();
    dataSource = FlexibleTableDataSource();
    scrollMixin = SynchronizedScrollController();

    AbsFlexibleTableColumn<StudentBean> idColumn = const StudentIdColumn()
        //设置列宽为固定宽度
        .appointWidth(FixedWidth(48));
    AbsFlexibleTableColumn<StudentBean> nameColumn = const StudentNameColumn()
        //设置列宽为父容器宽度的 0.5 倍
        .appointWidth(ProportionalWidth(0.5));
    AbsFlexibleTableColumn<StudentBean> ageColumn = const StudentAgeColumn()
        .appointWidth(FixedWidth(80))
        //给列头添加点击排序的功能
        .withSortByPressColumnHeader((column, a, b) => a.age.compareTo(b.age));
    AbsFlexibleTableColumn<StudentBean> genderColumn = const StudentGenderColumn()
        .appointWidth(FixedWidth(100))
        //给列信息项添加点击事件
        .whenInfoClicked((column, arguments, context) {
      debugPrint('点击了[${column.id}]列的第[${arguments.dataIndex}]项的数据[${arguments.data.gender}]');
    });

    rowBuilder = DefaultRowBuilder(
      this,
      leftPinnedColumns: {
        idColumn,
      },
      scrollableColumns: {
        nameColumn,
        ageColumn,
        genderColumn,
      },
    )
        //给行设置固定的高度
        .appointHeight(const FixedRowHeight(headerHeight: 32, infoHeight: 48));
    refreshData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  ScrollController createScrollController() {
    return scrollMixin;
  }

  @override
  void destroyScrollController(ScrollController controller) {}

  void refreshData() {
    // dataSource.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(children: [
        FlexibleTableHeader<StudentBean>(dataSource, rowBuilder: rowBuilder),
        Expanded(
          child: FlexibleTableContent<StudentBean>(dataSource, rowBuilder: rowBuilder),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshData,
        child: const Icon(Icons.refresh),
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

class StudentIdColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentIdColumn() : super('学号');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(id),
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
  const StudentNameColumn() : super('姓名');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Center(child: Text(id));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<StudentBean> arguments) {
    return Center(
      child: Text(
        arguments.data.name,
      ),
    );
  }
}

class StudentAgeColumn extends AbsFlexibleTableColumn<StudentBean> {
  const StudentAgeColumn() : super('年龄');

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<StudentBean> arguments) {
    return Center(child: Text(id));
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
    return Center(child: Text(id));
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
