import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/row_height/appointed_row_height.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///约定高度的行
final class AppointHeightRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const AppointHeightRowBuilder(
    this._builder, {
    required this.height,
  });

  final FlexibleTableRowBuilderMixin<T> _builder;
  final AppointedRowHeight<T> height;

  @override
  Widget buildHeaderRow(TableBuildArgumentsMixin<T> arguments) {
    return height.constrainHeaderRowHeight(arguments, _builder.buildHeaderRow(arguments));
  }

  @override
  Widget buildInfoRow(TableInfoRowArgumentsMixin<T> arguments) {
    return height.constrainInfoRowHeight(arguments, _builder.buildInfoRow(arguments));
  }
}
