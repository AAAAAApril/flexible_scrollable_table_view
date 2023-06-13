import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'table_build_arguments.dart';

///表行约束
mixin TableRowConstraintMixin<T> on AbsTableBuildArguments<T> {
  ///当前行的高度
  double get rowHeight;

  ///当前行的大小约束
  late final BoxConstraints rowConstraint = BoxConstraints.tightFor(width: parentWidth, height: rowHeight);
}

///构建表行所需参数
class TableRowBuildArguments<T> extends AbsTableBuildArguments<T> {
  TableRowBuildArguments(
    this.controller,
    this.configurations,
    this.parentWidth,
  );

  @override
  final FlexibleTableController<T> controller;

  @override
  final AbsFlexibleTableConfigurations<T> configurations;

  @override
  final double parentWidth;

  @override
  late final List<AbsFlexibleColumn<T>> leftPinnedColumnList = configurations.leftPinnedColumns.toList(growable: false);
  @override
  late final List<AbsFlexibleColumn<T>> rightPinnedColumnList =
      configurations.rightPinnedColumns.toList(growable: false);

  @override
  late final List<AbsFlexibleColumn<T>> scrollableColumnList = configurations.scrollableColumns.toList(growable: false);
}

///构建表头行所需参数
class TableHeaderRowBuildArguments<T> extends TableRowBuildArguments<T> with TableRowConstraintMixin<T> {
  TableHeaderRowBuildArguments(
    super.controller,
    super.configurations,
    super.parentWidth,
  );

  @override
  late final double rowHeight = configurations.rowHeight.headerRowHeight;
}

///构建表信息行所需参数
class TableInfoRowBuildArguments<T> extends TableRowBuildArguments<T> with TableRowConstraintMixin<T> {
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
  final int dataIndex;

  ///数据总长度
  late final int dataLength = _dataList.length;

  ///当前 列表项 下标
  final int itemIndex;

  ///列表项 总数
  final int itemCount;

  ///当前行数据
  late final T data = _dataList[dataIndex];

  @override
  late final double rowHeight = configurations.rowHeight.getInfoRowHeight(controller, dataIndex, data);
}

extension TableRowBuildArgumentsExt<T> on TableRowBuildArguments<T> {
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
