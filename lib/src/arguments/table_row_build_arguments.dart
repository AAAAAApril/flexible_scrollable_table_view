import 'table_build_arguments.dart';

///构建表头行所需参数
class TableHeaderRowBuildArguments<T> extends TableBuildArguments<T> with TableRowConstraintMixin<T> {
  TableHeaderRowBuildArguments(
    super.controller,
    super.configurations,
    super.parentWidth,
  );

  @override
  late final double rowHeight = configurations.rowHeight.headerRowHeight;
}

///构建表信息行所需参数
class TableInfoRowBuildArguments<T> extends TableBuildArguments<T>
    with TableRowConstraintMixin<T>, TableInfoRowArgumentsMixin<T> {
  TableInfoRowBuildArguments(
    super.controller,
    super.configurations,
    super.parentWidth,
    this._dataList,
    this.dataIndex,
    this.itemIndex,
    this.itemCount,
  );

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
        controller,
        configurations,
        parentWidth,
      );

  TableInfoRowBuildArguments<T> toInfoRowArguments({
    required List<T> dataList,
    required int dataIndex,
    required int currentItemIndex,
    required int totalItemCount,
  }) =>
      TableInfoRowBuildArguments<T>(
        controller,
        configurations,
        parentWidth,
        dataList,
        dataIndex,
        currentItemIndex,
        totalItemCount,
      );
}
