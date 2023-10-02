import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///给信息行添加点击事件
final class PressableInfoRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const PressableInfoRowBuilder(
    this._rowBuilder, {
    this.onPressed,
    this.onLongPressed,
  });

  final FlexibleTableRowBuilderMixin<T> _rowBuilder;

  final void Function(TableInfoRowArgumentsMixin<T> arguments, BuildContext context)? onPressed;
  final void Function(TableInfoRowArgumentsMixin<T> arguments, BuildContext context)? onLongPressed;

  @override
  Widget buildHeaderRow(TableBuildArgumentsMixin<T> arguments) {
    return _rowBuilder.buildHeaderRow(arguments);
  }

  @override
  Widget buildInfoRow(TableInfoRowArgumentsMixin<T> arguments) {
    if (onPressed == null && onLongPressed == null) {
      return _rowBuilder.buildInfoRow(arguments);
    }
    return Builder(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed != null ? () => onPressed!.call(arguments, context) : null,
        onLongPress: onLongPressed != null ? () => onLongPressed!.call(arguments, context) : null,
        child: _rowBuilder.buildInfoRow(arguments),
      ),
    );
  }
}
