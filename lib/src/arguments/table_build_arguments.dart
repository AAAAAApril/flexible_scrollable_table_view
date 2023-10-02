import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';

///构建表行所需参数
mixin TableBuildArgumentsMixin<T> {
  ///数据源
  FlexibleTableDataSource<T> get dataSource;

  ///父容器宽度
  double get parentWidth;
}

///行数据
mixin TableInfoRowArgumentsMixin<T> implements TableBuildArgumentsMixin<T> {
  ///当前行所在下标
  int get dataIndex;

  ///数据总长度
  int get dataLength;

  ///当前 列表项 下标
  int get itemIndex;

  ///列表项 总数
  int get itemCount;

  ///当前行数据
  T get data;
}

///构建表所需参数
class TableBuildArguments<T> with TableBuildArgumentsMixin<T> {
  const TableBuildArguments({
    required this.dataSource,
    required this.parentWidth,
  });

  @override
  final FlexibleTableDataSource<T> dataSource;

  @override
  final double parentWidth;
}

extension TableBuildArgumentsExt<T> on TableBuildArgumentsMixin<T> {
  TableBuildArgumentsMixin<T> toHeaderRowArguments() => TableBuildArguments<T>(
        dataSource: dataSource,
        parentWidth: parentWidth,
      );
}
