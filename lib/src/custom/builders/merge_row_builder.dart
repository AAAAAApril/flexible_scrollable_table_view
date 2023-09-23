import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///合并多个[行]为同一[行]
final class MergeRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const MergeRowBuilder(this._builders);

  final Iterable<FlexibleTableRowBuilderMixin<T>> _builders;

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _builders.map<Widget>((e) => e.buildHeaderRow(arguments)).toList(growable: false),
      ),
    );
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _builders.map<Widget>((e) => e.buildInfoRow(arguments)).toList(growable: false),
      ),
    );
  }
}
