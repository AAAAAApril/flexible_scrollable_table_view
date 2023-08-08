import 'table_build_arguments.dart';

///构建表头行所需参数
class TableHeaderRowBuildArguments<T> extends TableBuildArguments<T> with TableRowConstraintMixin<T> {
  TableHeaderRowBuildArguments({
    required super.dataSource,
    required super.horizontalScrollMixin,
    required super.configurations,
    required super.parentWidth,
  });

  @override
  late final double rowHeight = configurations.rowHeight.headerRowHeight;
}

///构建表信息行所需参数
class TableInfoRowBuildArguments<T> extends TableBuildArguments<T>
    with TableRowConstraintMixin<T>, TableInfoRowArgumentsMixin<T> {
  TableInfoRowBuildArguments({
    required super.dataSource,
    required super.horizontalScrollMixin,
    required super.configurations,
    required super.parentWidth,
    required List<T> dataList,
    required this.dataIndex,
    required this.itemIndex,
    required this.itemCount,
  }) : _dataList = dataList;

  ///所有数据
  final List<T> _dataList;

  ///当前行所在下标
  @override
  final int dataIndex;

  ///数据总长度
  @override
  late final int dataLength = _dataList.length;

  ///当前 列表项 下标
  @override
  final int itemIndex;

  ///列表项 总数
  @override
  final int itemCount;

  ///当前行数据
  @override
  late final T data = _dataList[dataIndex];

  @override
  late final double rowHeight = configurations.rowHeight.getInfoRowHeight(this);
}

extension TableBuildArgumentsExt<T> on AbsTableBuildArguments<T> {
  TableHeaderRowBuildArguments<T> toHeaderRowArguments() => TableHeaderRowBuildArguments<T>(
        dataSource: dataSource,
        horizontalScrollMixin: horizontalScrollMixin,
        configurations: configurations,
        parentWidth: parentWidth,
      );

  TableInfoRowBuildArguments<T> toInfoRowArguments({
    required List<T> dataList,
    required int dataIndex,
    required int currentItemIndex,
    required int totalItemCount,
  }) =>
      TableInfoRowBuildArguments<T>(
        dataSource: dataSource,
        horizontalScrollMixin: horizontalScrollMixin,
        configurations: configurations,
        parentWidth: parentWidth,
        dataList: dataList,
        dataIndex: dataIndex,
        itemIndex: currentItemIndex,
        itemCount: totalItemCount,
      );
}
