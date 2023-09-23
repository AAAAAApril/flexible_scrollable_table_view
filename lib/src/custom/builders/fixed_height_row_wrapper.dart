import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///具有固定高度的行构造器
final class FixedHeightRowWrapper<T> with FlexibleTableRowBuilderMixin<T> {
  const FixedHeightRowWrapper(
    this._builder, {
    required this.headerRowHeight,
    required this.infoRowHeight,
  });

  final FlexibleTableRowBuilderMixin<T> _builder;
  final double headerRowHeight;
  final double infoRowHeight;

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      height: headerRowHeight,
      child: _builder.buildHeaderRow(arguments),
    );
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      height: infoRowHeight,
      child: _builder.buildInfoRow(arguments),
    );
  }
}

