import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///定制化的可选中的 Column
mixin SelectableColumnMixin<T> on AbsFlexibleColumn<T> {
  ///可选状态时的固定宽度
  AbsFlexibleTableColumnWidth<T> get selectableWidth;

  ///非可选状态时的固定宽度
  AbsFlexibleTableColumnWidth<T> get unSelectableWidth;

  @override
  AbsFlexibleTableColumnWidth<T> get columnWidth => selectableWidth;

  @override
  Widget buildHeaderCellInternal(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return child!;
        }
        return buildHeaderUnSelectableCellInternal(arguments, animations);
      },
      child: super.buildHeaderCellInternal(arguments, animations),
    );
  }

  Widget buildHeaderUnSelectableCellInternal(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    final Widget child = arguments.rowHeight <= 0 ? const SizedBox.shrink() : buildUnSelectableHeaderCell(arguments);
    final BoxConstraints constraints = BoxConstraints.tightFor(
      width: unSelectableWidth.getColumnWidth(arguments),
      height: arguments.rowHeight,
    );
    return animations?.buildTableHeaderCellConstraintAnimationWidget(
          arguments,
          this,
          constraints: constraints,
          cellWidget: child,
        ) ??
        ConstrainedBox(constraints: constraints, child: child);
  }

  @override
  Widget buildInfoCellInternal(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: arguments.dataSource.selectable,
      builder: (context, selectable, child) {
        if (selectable) {
          return child!;
        }
        return buildInfoUnSelectableCellInternal(arguments, animations);
      },
      child: super.buildInfoCellInternal(arguments, animations),
    );
  }

  Widget buildInfoUnSelectableCellInternal(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    final Widget child = arguments.rowHeight <= 0 ? const SizedBox.shrink() : buildUnSelectableInfoCell(arguments);
    final BoxConstraints constraints = BoxConstraints.tightFor(
      width: unSelectableWidth.getColumnWidth(arguments),
      height: arguments.rowHeight,
    );
    return animations?.buildTableInfoCellConstraintAnimationWidget(
          arguments,
          this,
          constraints: constraints,
          cellWidget: child,
        ) ??
        ConstrainedBox(constraints: constraints, child: child);
  }

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) => buildSelectableHeaderCell(arguments);

  ///构建可编辑时的表头
  @protected
  Widget buildSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建不可编辑时的表头
  @protected
  Widget buildUnSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments));

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) => buildSelectableInfoCell(arguments);

  ///构建可编辑时的表信息
  @protected
  Widget buildSelectableInfoCell(TableInfoRowBuildArguments<T> arguments);

  ///构建不可编辑时的表信息
  @protected
  Widget buildUnSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      SizedBox(width: unSelectableWidth.getColumnWidth(arguments));
}

abstract class AbsSelectableColumn<T> extends AbsFlexibleColumn<T> with SelectableColumnMixin<T> {
  const AbsSelectableColumn(super.id);
}

class SelectableColumn<T> extends AbsSelectableColumn<T> {
  const SelectableColumn(
    super.id, {
    required this.selectableWidth,
    this.unSelectableWidth = const FixedWidth(0),
    this.selectableHeader,
    this.selectableHeaderBuilder,
    this.unSelectableHeader,
    this.unSelectableHeaderBuilder,
    this.selectableInfo,
    this.selectableInfoBuilder,
    this.unSelectableInfo,
    this.unSelectableInfoBuilder,
  });

  @override
  final AbsFlexibleTableColumnWidth<T> selectableWidth;

  @override
  final AbsFlexibleTableColumnWidth<T> unSelectableWidth;

  final Widget? selectableHeader;
  final Widget Function(TableHeaderRowBuildArguments<T> arguments, SelectableColumnMixin<T> column)?
      selectableHeaderBuilder;

  final Widget? unSelectableHeader;
  final Widget Function(TableHeaderRowBuildArguments<T> arguments, SelectableColumnMixin<T> column)?
      unSelectableHeaderBuilder;

  final Widget? selectableInfo;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, SelectableColumnMixin<T> column)?
      selectableInfoBuilder;

  final Widget? unSelectableInfo;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, SelectableColumnMixin<T> column)?
      unSelectableInfoBuilder;

  @override
  Widget buildSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      selectableHeaderBuilder?.call(arguments, this) ?? selectableHeader ?? const SizedBox.shrink();

  @override
  Widget buildUnSelectableHeaderCell(TableHeaderRowBuildArguments<T> arguments) {
    return unSelectableHeaderBuilder?.call(arguments, this) ??
        unSelectableHeader ??
        super.buildUnSelectableHeaderCell(arguments);
  }

  @override
  Widget buildSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      selectableInfoBuilder?.call(arguments, this) ?? selectableInfo ?? const SizedBox.shrink();

  @override
  Widget buildUnSelectableInfoCell(TableInfoRowBuildArguments<T> arguments) {
    return unSelectableInfoBuilder?.call(arguments, this) ??
        unSelectableInfo ??
        super.buildUnSelectableInfoCell(arguments);
  }
}
