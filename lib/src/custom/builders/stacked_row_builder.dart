import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///层叠的行构造器
final class StackedRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  StackedRowBuilder(
    this._baseRowBuilder, {
    Iterable<FlexibleTableRowBuilderMixin<T>>? aboveBuilders,
    Iterable<FlexibleTableRowBuilderMixin<T>>? belowBuilders,
  })  : _aboveBuilders = aboveBuilders ?? <FlexibleTableRowBuilderMixin<T>>{},
        _belowBuilders = belowBuilders ?? <FlexibleTableRowBuilderMixin<T>>{};

  final FlexibleTableRowBuilderMixin<T> _baseRowBuilder;

  ///叠加在[_baseRowBuilder]上层
  final Iterable<FlexibleTableRowBuilderMixin<T>> _aboveBuilders;

  ///叠加在[_baseRowBuilder]下层
  final Iterable<FlexibleTableRowBuilderMixin<T>> _belowBuilders;

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    if (_aboveBuilders.isEmpty && _belowBuilders.isEmpty) {
      return _baseRowBuilder.buildHeaderRow(arguments);
    }
    return Stack(children: [
      ..._belowBuilders.map<Widget>(
        (e) => Positioned.fill(child: e.buildHeaderRow(arguments)),
      ),
      _baseRowBuilder.buildHeaderRow(arguments),
      ..._aboveBuilders.map<Widget>(
        (e) => Positioned.fill(child: e.buildHeaderRow(arguments)),
      ),
    ]);
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    if (_aboveBuilders.isEmpty && _belowBuilders.isEmpty) {
      return _baseRowBuilder.buildInfoRow(arguments);
    }
    return Stack(children: [
      ..._belowBuilders.map<Widget>(
        (e) => Positioned.fill(child: e.buildInfoRow(arguments)),
      ),
      _baseRowBuilder.buildInfoRow(arguments),
      ..._aboveBuilders.map<Widget>(
        (e) => Positioned.fill(child: e.buildInfoRow(arguments)),
      ),
    ]);
  }
}
