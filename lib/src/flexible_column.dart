import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flutter/widgets.dart';

///列信息配置类
abstract class AbsFlexibleColumn<T> {
  const AbsFlexibleColumn(this.id);

  ///列 id，需要保持唯一
  final String id;

  ///构建表头
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建表信息
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments);

  AbsFlexibleColumn<T>? findColumnById(String columnId) {
    return columnId == id ? this : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsFlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
