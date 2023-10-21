import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

abstract class AppointedRowHeight<T> {
  const AppointedRowHeight();

  ///约束表头行高度
  Widget constrainHeaderRowHeight(TableBuildArgumentsMixin<T> arguments, Widget rowWidget);

  ///约束表信息行高度
  Widget constrainInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments, Widget rowWidget);
}
