import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///给行添加装饰
final class DecorationRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const DecorationRowBuilder(
    this._builder, {
    this.position = DecorationPosition.background,
    this.headerRowDecoration,
    this.infoRowDecoration,
  });

  final FlexibleTableRowBuilderMixin<T> _builder;

  final Decoration Function(TableBuildArgumentsMixin<T> arguments)? headerRowDecoration;
  final Decoration Function(TableInfoRowArgumentsMixin<T> arguments)? infoRowDecoration;
  final DecorationPosition position;

  @override
  Widget buildHeaderRow(TableBuildArgumentsMixin<T> arguments) {
    Widget child = _builder.buildHeaderRow(arguments);
    if (headerRowDecoration != null) {
      child = DecoratedBox(
        decoration: headerRowDecoration!.call(arguments),
        position: position,
        child: child,
      );
    }
    return child;
  }

  @override
  Widget buildInfoRow(TableInfoRowArgumentsMixin<T> arguments) {
    Widget child = _builder.buildInfoRow(arguments);
    if (infoRowDecoration != null) {
      child = DecoratedBox(
        decoration: infoRowDecoration!.call(arguments),
        position: position,
        child: child,
      );
    }
    return child;
  }
}
