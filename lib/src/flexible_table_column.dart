import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flutter/widgets.dart';

///列信息配置类
abstract class AbsFlexibleTableColumn<T> {
  const AbsFlexibleTableColumn(this.id);

  ///列 id，需要保持唯一
  final String id;

  ///构建表头
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建表信息
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments);

  AbsFlexibleTableColumn<T>? findColumnById(String columnId) {
    return columnId == id ? this : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsFlexibleTableColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

abstract class AbsFlexibleTableColumnWithChild<T> extends AbsFlexibleTableColumn<T> {
  const AbsFlexibleTableColumnWithChild(super.id);

  AbsFlexibleTableColumn<T> get child;

  @override
  AbsFlexibleTableColumn<T>? findColumnById(String columnId) {
    return child.findColumnById(columnId) ?? super.findColumnById(columnId);
  }
}

abstract class AbsFlexibleTableColumnWithChildren<T> extends AbsFlexibleTableColumn<T> {
  const AbsFlexibleTableColumnWithChildren(super.id);

  Iterable<AbsFlexibleTableColumn<T>> get children;

  @override
  AbsFlexibleTableColumn<T>? findColumnById(String columnId) {
    for (var value in children) {
      var result = value.findColumnById(columnId);
      if (result != null) {
        return result;
      }
    }
    return super.findColumnById(columnId);
  }
}
