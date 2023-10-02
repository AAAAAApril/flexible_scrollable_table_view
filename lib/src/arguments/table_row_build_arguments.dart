import 'table_build_arguments.dart';

///构建表信息行所需参数
class TableInfoRowBuildArguments<T> extends TableBuildArguments<T> with TableInfoRowArgumentsMixin<T> {
  TableInfoRowBuildArguments({
    required super.dataSource,
    required super.parentWidth,
    required this.dataIndex,
    required this.itemIndex,
    required this.itemCount,
  });

  @override
  final int dataIndex;

  @override
  late final int dataLength = dataSource.value.length;

  @override
  final int itemIndex;

  @override
  final int itemCount;

  @override
  late final T data = dataSource.value[dataIndex];
}

extension TableInfoRowBuildArgumentsExt<T> on TableBuildArgumentsMixin<T> {
  TableInfoRowArgumentsMixin<T> toInfoRowArguments({
    required int dataIndex,
    required int currentItemIndex,
    required int totalItemCount,
  }) =>
      TableInfoRowBuildArguments<T>(
        dataSource: dataSource,
        parentWidth: parentWidth,
        dataIndex: dataIndex,
        itemIndex: currentItemIndex,
        itemCount: totalItemCount,
      );
}
