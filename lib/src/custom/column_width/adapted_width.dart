import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/column_width/appointed_column_width.dart';
import 'package:flutter/widgets.dart';

///自适应列宽
final class AdaptedWidth<T> extends AppointedColumnWidth<T> {
  @override
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    // TODO: implement constrainWidth
    throw UnimplementedError();
  }
}
