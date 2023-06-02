import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

///可以切换列宽的列
abstract class AbsSwitchableColumn<T> extends AbsFlexibleColumn<T>{
  const AbsSwitchableColumn(super.id);

}

class SwitchableColumn<T> extends AbsFlexibleColumn<T>{
  SwitchableColumn(super.id);

  @override
  Widget buildHeader(TableHeaderRowBuildArguments<T> arguments) {
    // TODO: implement buildHeader
    throw UnimplementedError();
  }

  @override
  Widget buildInfo(TableInfoRowBuildArguments<T> arguments) {
    // TODO: implement buildInfo
    throw UnimplementedError();
  }

  @override
  // TODO: implement columnWidth
  AbsFlexibleTableColumnWidth get columnWidth => throw UnimplementedError();
}
