import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

abstract class AppointedColumnWidth<T> {
  const AppointedColumnWidth();

  ///约束宽度
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell);
}

///已知宽度
mixin KnownColumnWidthMixin<T> on AppointedColumnWidth<T> {
  ///获取已知的宽度
  double getKnownWidth(TableBuildArgumentsMixin<T> arguments);

  @override
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    return SizedBox(width: getKnownWidth(arguments), height: double.infinity, child: columnCell);
  }
}
