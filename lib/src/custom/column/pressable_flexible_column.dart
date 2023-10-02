import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_column.dart';
import 'package:flutter/widgets.dart';

///列头可点击列
final class HeaderPressableColumn<T> extends AbsFlexibleTableColumnWithChild<T> {
  HeaderPressableColumn(
    this.child, {
    required this.onHeaderClicked,
    this.expandPressArea = false,
  }) : super(child.id);

  @override
  final AbsFlexibleTableColumn<T> child;
  final bool expandPressArea;

  final void Function(
    AbsFlexibleTableColumn<T> column,
    TableHeaderRowBuildArguments<T> arguments,
    BuildContext context,
  ) onHeaderClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return Builder(
      builder: (context) {
        Widget result = child.buildHeaderCell(arguments);
        if (expandPressArea) {
          result = SizedBox.expand(child: result);
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onHeaderClicked.call(this, arguments, context),
          child: result,
        );
      },
    );
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return child.buildInfoCell(arguments);
  }
}

///列信息可点击列
final class InfoPressableColumn<T> extends AbsFlexibleTableColumnWithChild<T> {
  InfoPressableColumn(
    this.child, {
    required this.onInfoClicked,
    this.expandPressArea = false,
  }) : super(child.id);

  @override
  final AbsFlexibleTableColumn<T> child;
  final bool expandPressArea;

  final void Function(
    AbsFlexibleTableColumn<T> column,
    TableInfoRowBuildArguments<T> arguments,
    BuildContext context,
  ) onInfoClicked;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return child.buildHeaderCell(arguments);
  }

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return Builder(
      builder: (context) {
        Widget result = child.buildInfoCell(arguments);
        if (expandPressArea) {
          result = SizedBox.expand(child: result);
        }
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onInfoClicked.call(this, arguments, context),
          child: result,
        );
      },
    );
  }
}
