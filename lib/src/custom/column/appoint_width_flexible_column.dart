import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/column_width/appointed_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///约定宽度的列
final class AppointWidthFlexibleColumn<T> extends AbsFlexibleTableColumnWithChild<T> {
  AppointWidthFlexibleColumn(
    this.child, {
    required this.width,
  }) : super(child.id);

  @override
  final AbsFlexibleTableColumn<T> child;
  final AppointedColumnWidth<T> width;

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<T> arguments) {
    return width.constrainWidth(arguments, child.buildHeaderCell(arguments));
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<T> arguments) {
    return width.constrainWidth(arguments, child.buildInfoCell(arguments));
  }
}
