import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///层叠的列
final class StackedFlexibleColumn<T> extends AbsFlexibleTableColumnWithChildren<T> {
  StackedFlexibleColumn(
    this._base, {
    Iterable<AbsFlexibleTableColumn<T>>? above,
    Iterable<AbsFlexibleTableColumn<T>>? below,
  })  : _above = above ?? <AbsFlexibleTableColumn<T>>{},
        _below = below ?? <AbsFlexibleTableColumn<T>>{},
        super(_base.id);

  final AbsFlexibleTableColumn<T> _base;
  final Iterable<AbsFlexibleTableColumn<T>> _above;
  final Iterable<AbsFlexibleTableColumn<T>> _below;

  @override
  late final Iterable<AbsFlexibleTableColumn<T>> children = <AbsFlexibleTableColumn<T>>{_base};

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<T> arguments) {
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
  Widget buildInfoCell(TableInfoRowArgumentsMixin<T> arguments) {
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
