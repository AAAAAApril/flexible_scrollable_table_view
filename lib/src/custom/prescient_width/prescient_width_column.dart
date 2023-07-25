import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

import 'prescient_width.dart';
import 'prescient_width_group.dart';

mixin PrescientWidthColumnMixin<T> on AbsFlexibleColumn<T> {
  @override
  PrescientWidthMixin<T> get columnWidth;

  @override
  Widget buildHeaderCellInternal(TableHeaderRowBuildArguments<T> arguments, AbsFlexibleTableAnimations<T>? animations) {
    return PrescientWidthChild(
      -1,
      key: ValueKey<String>('${arguments.controller.hashCode}_${id}_-1'),
      group: columnWidth.widthGroup,
      width: columnWidth.getColumnWidthOfHeaderCell(arguments),
      child: ValueListenableBuilder<double>(
        key: ValueKey<String>('${arguments.controller.hashCode}_${id}_-1_vlb'),
        valueListenable: columnWidth.widthGroup,
        builder: (context, value, child) {
          final BoxConstraints constraints = BoxConstraints.tightFor(
            width: value,
            height: arguments.rowHeight,
          );
          return animations?.buildTableHeaderCellConstraintAnimationWidget(
                arguments,
                this,
                constraints: constraints,
                cellWidget: child!,
              ) ??
              ConstrainedBox(constraints: constraints, child: child);
        },
        child: buildHeaderCell(arguments),
      ),
    );
  }

  @override
  Widget buildInfoCellInternal(TableInfoRowBuildArguments<T> arguments, AbsFlexibleTableAnimations<T>? animations) {
    return PrescientWidthChild(
      arguments.dataIndex,
      key: ValueKey<String>('${arguments.controller.hashCode}_${id}_${arguments.dataIndex}'),
      group: columnWidth.widthGroup,
      width: columnWidth.getColumnWidthOfInfoCell(arguments),
      child: ValueListenableBuilder<double>(
        key: ValueKey<String>('${arguments.controller.hashCode}_${id}_${arguments.dataIndex}_vlb'),
        valueListenable: columnWidth.widthGroup,
        builder: (context, value, child) {
          final BoxConstraints constraints = BoxConstraints.tightFor(
            width: value,
            height: arguments.rowHeight,
          );
          return animations?.buildTableInfoCellConstraintAnimationWidget(
                arguments,
                this,
                constraints: constraints,
                cellWidget: child!,
              ) ??
              ConstrainedBox(constraints: constraints, child: child);
        },
        child: buildInfoCell(arguments),
      ),
    );
  }
}

abstract class AbsPrescientWidthColumn<T> extends AbsFlexibleColumn<T> with PrescientWidthColumnMixin<T> {
  const AbsPrescientWidthColumn(super.id);
}

class PrescientWidthColumn<T> extends AbsPrescientWidthColumn<T> {
  PrescientWidthColumn(
    super.id, {
    required this.columnWidth,
    required this.header,
    required this.infoBuilder,
  });

  @override
  final PrescientWidthMixin<T> columnWidth;

  final Widget header;
  final Widget Function(TableInfoRowBuildArguments<T> arguments) infoBuilder;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) => header;

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) => infoBuilder.call(arguments);
}
