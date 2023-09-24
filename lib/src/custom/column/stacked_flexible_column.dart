import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///层叠的列
final class StackedFlexibleColumn<T> extends AbsFlexibleColumnWithChildren<T> {
  StackedFlexibleColumn(
    this._base, {
    Iterable<AbsFlexibleColumn<T>>? above,
    Iterable<AbsFlexibleColumn<T>>? below,
  })  : _above = above ?? <AbsFlexibleColumn<T>>{},
        _below = below ?? <AbsFlexibleColumn<T>>{},
        super(_base.id);

  final AbsFlexibleColumn<T> _base;
  final Iterable<AbsFlexibleColumn<T>> _above;
  final Iterable<AbsFlexibleColumn<T>> _below;

  @override
  late final Iterable<AbsFlexibleColumn<T>> children = <AbsFlexibleColumn<T>>{_base};

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    if (_above.isEmpty && _below.isEmpty) {
      return _base.buildHeaderCell(arguments);
    }
    return Stack(children: [
      ..._below.map<Widget>(
        (e) => Positioned.fill(child: e.buildHeaderCell(arguments)),
      ),
      _base.buildHeaderCell(arguments),
      ..._above.map<Widget>(
        (e) => Positioned.fill(child: e.buildHeaderCell(arguments)),
      ),
    ]);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    if (_above.isEmpty && _below.isEmpty) {
      return _base.buildInfoCell(arguments);
    }
    return Stack(children: [
      ..._below.map<Widget>(
        (e) => Positioned.fill(child: e.buildInfoCell(arguments)),
      ),
      _base.buildInfoCell(arguments),
      ..._above.map<Widget>(
        (e) => Positioned.fill(child: e.buildInfoCell(arguments)),
      ),
    ]);
  }
}
