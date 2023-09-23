import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

typedef BlankColumn = EmptyFlexibleColumn;
typedef SpacerColumn = SpacerFlexibleColumn;

///空白列，只有宽度，没有具体内容
final class EmptyFlexibleColumn<T> extends AbsFlexibleColumn<T> {
  EmptyFlexibleColumn(super.id, this.width);

  final double width;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(width: width, height: 0);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(width: width, height: 0);
  }
}

///撑开，但没有内容的列
final class SpacerFlexibleColumn<T> extends AbsFlexibleColumn<T> {
  SpacerFlexibleColumn(super.id, this.flex);

  final int flex;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return Spacer(flex: flex);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return Spacer(flex: flex);
  }
}
