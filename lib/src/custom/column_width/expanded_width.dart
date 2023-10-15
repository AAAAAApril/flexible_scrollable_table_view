import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

import 'appointed_column_width.dart';

///撑开空间
final class ExpandedWidth<T> extends AppointedColumnWidth<T> {
  const ExpandedWidth({
    this.flex = 1,
    this.fit = FlexFit.tight,
  });

  final int flex;
  final FlexFit fit;

  @override
  Widget constrainWidth(TableBuildArgumentsMixin<T> arguments, Widget columnCell) {
    return Flexible(flex: flex, fit: fit, child: columnCell);
  }
}
