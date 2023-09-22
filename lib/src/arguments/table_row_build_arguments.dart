import 'table_build_arguments.dart';

///构建表头行所需参数
class TableHeaderRowBuildArguments<T> extends TableBuildArguments<T> {
  const TableHeaderRowBuildArguments({
    required super.dataSource,
    required super.parentWidth,
  });
}

///构建表信息行所需参数
class TableInfoRowBuildArguments<T> extends TableBuildArguments<T> with TableInfoRowArgumentsMixin<T> {
  TableInfoRowBuildArguments({
    required super.dataSource,
    required super.parentWidth,
    required List<T> dataList,
    required this.dataIndex,
    required this.itemIndex,
    required this.itemCount,
  }) : _dataList = dataList;

  final List<T> _dataList;

  @override
  final int dataIndex;

  @override
  late final int dataLength = _dataList.length;

  @override
  final int itemIndex;

  @override
  final int itemCount;

  @override
  late final T data = _dataList[dataIndex];
}

extension TableBuildArgumentsExt<T> on AbsTableBuildArguments<T> {
  TableHeaderRowBuildArguments<T> toHeaderRowArguments() => TableHeaderRowBuildArguments<T>(
        dataSource: dataSource,
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
        parentWidth: parentWidth,
        dataList: dataList,
        dataIndex: dataIndex,
        itemIndex: currentItemIndex,
        itemCount: totalItemCount,
      );
}
