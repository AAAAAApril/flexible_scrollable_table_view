import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

import 'appointed_row_height.dart';

///固定的行高
final class FixedHeight<T> extends AppointedRowHeight<T> {
  const FixedHeight({
    required this.headerHeight,
    required this.infoHeight,
  });

  final double headerHeight;
  final double infoHeight;

  @override
  Widget constrainHeaderRowHeight(TableBuildArgumentsMixin<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: headerHeight, child: rowWidget);
  }

  @override
  Widget constrainInfoRowHeight(TableInfoRowArgumentsMixin<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: infoHeight, child: rowWidget);
  }
}
