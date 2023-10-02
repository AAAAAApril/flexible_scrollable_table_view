import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/material.dart';

///分割线行
final class DividerRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const DividerRowBuilder(
    this._builder, {
    this.aroundHeaderRow = false,
    this.outsideOfRowItem = false,
  });

  final FlexibleTableRowBuilderMixin<T> _builder;

  final bool aroundHeaderRow;
  final bool outsideOfRowItem;

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    Widget child = _builder.buildHeaderRow(arguments);
    if (!aroundHeaderRow) {
      return child;
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      const Divider(),
      child,
      const Divider(),
    ]);
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      if (arguments.dataIndex == 0 && outsideOfRowItem) const Divider(),
      _builder.buildInfoRow(arguments),
      if (arguments.dataIndex != arguments.dataLength - 1 || outsideOfRowItem) const Divider(),
    ]);
  }
}
