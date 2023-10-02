import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
final class SelectableColumn<T> extends AbsFlexibleTableColumn<T> {
  SelectableColumn({
    required this.selectableColumn,
    required this.unSelectableColumn,
  }) : super('${selectableColumn.id}_${unSelectableColumn.id}');

  final AbsFlexibleTableColumn<T> selectableColumn;
  final AbsFlexibleTableColumn<T> unSelectableColumn;

  @override
  Widget buildHeaderCell(TableBuildArgumentsMixin<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return selectableColumn.buildHeaderCell(arguments);
        }
        return unSelectableColumn.buildHeaderCell(arguments);
      },
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowArgumentsMixin<T> arguments) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return selectableColumn.buildInfoCell(arguments);
        }
        return unSelectableColumn.buildInfoCell(arguments);
      },
    );
  }
}
