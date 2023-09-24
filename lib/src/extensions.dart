import 'package:flutter/widgets.dart';

import 'arguments/table_row_build_arguments.dart';
import 'custom/builders/appoint_height_row_builder.dart';
import 'custom/builders/merge_row_builder.dart';
import 'custom/builders/pressable_row_builder.dart';
import 'custom/builders/stacked_row_builder.dart';
import 'custom/column/appoint_width_flexible_column.dart';
import 'custom/column/pressable_flexible_column.dart';
import 'custom/column/stacked_flexible_column.dart';
import 'flexible_column.dart';
import 'flexible_table_row_builder.dart';
import 'selectable/selectable_column.dart';
import 'sortable/sortable_column.dart';

extension AbsFlexibleColumnExt<T> on AbsFlexibleColumn<T> {
  AbsFlexibleColumn<T> withSortByPressColumnHeader(
    int Function(SortableColumnMixin<T> column, T a, T b) compare,
  ) {
    return SortableColumn<T>(this, compareValue: compare);
  }

  AbsFlexibleColumn<T> appointWidth(AppointedColumnWidth<T> width) {
    return AppointWidthFlexibleColumn<T>(this, width: width);
  }

  AbsFlexibleColumn<T> withStacks({
    Iterable<AbsFlexibleColumn<T>>? above,
    Iterable<AbsFlexibleColumn<T>>? below,
  }) {
    if ((above == null || above.isEmpty) && (below == null || below.isEmpty)) {
      return this;
    }
    return StackedFlexibleColumn<T>(this, above: above, below: below);
  }

  AbsFlexibleColumn<T> whenHeaderClicked(
    void Function(
      AbsFlexibleColumn<T> column,
      TableHeaderRowBuildArguments<T> arguments,
      BuildContext context,
    ) onClicked, {
    bool expandPressArea = false,
  }) {
    return HeaderPressableColumn<T>(this, onHeaderClicked: onClicked, expandPressArea: expandPressArea);
  }

  AbsFlexibleColumn<T> whenInfoClicked(
    void Function(
      AbsFlexibleColumn<T> column,
      TableInfoRowBuildArguments<T> arguments,
      BuildContext context,
    ) onClicked, {
    bool expandPressArea = false,
  }) {
    return InfoPressableColumn<T>(this, onInfoClicked: onClicked, expandPressArea: expandPressArea);
  }

  AbsFlexibleColumn<T> asSelectableColumn(AbsFlexibleColumn<T> unSelectableColumn) {
    return SelectableColumn<T>(selectableColumn: this, unSelectableColumn: unSelectableColumn);
  }

  AbsFlexibleColumn<T> asUnSelectableColumn(AbsFlexibleColumn<T> selectableColumn) {
    return SelectableColumn<T>(selectableColumn: selectableColumn, unSelectableColumn: this);
  }
}

extension TableRowBuilderExt<T> on FlexibleTableRowBuilderMixin<T> {
  FlexibleTableRowBuilderMixin<T> appointHeight(AppointedRowHeight<T> height) {
    return AppointHeightRowBuilder<T>(this, height: height);
  }

  FlexibleTableRowBuilderMixin<T> withStacks({
    Iterable<FlexibleTableRowBuilderMixin<T>>? above,
    Iterable<FlexibleTableRowBuilderMixin<T>>? below,
  }) {
    if ((above == null || above.isEmpty) && (below == null || below.isEmpty)) {
      return this;
    }
    return StackedRowBuilder<T>(this, aboveBuilders: above, belowBuilders: below);
  }

  FlexibleTableRowBuilderMixin<T> whenPressed({
    void Function(TableInfoRowBuildArguments<T> arguments, BuildContext context)? onPressed,
    void Function(TableInfoRowBuildArguments<T> arguments, BuildContext context)? onLongPressed,
  }) {
    if (onPressed == null && onLongPressed == null) {
      return this;
    }
    return PressableInfoRowBuilder<T>(this, onPressed: onPressed, onLongPressed: onLongPressed);
  }
}

extension IterableTableRowBuilderExt<T> on Iterable<FlexibleTableRowBuilderMixin<T>> {
  FlexibleTableRowBuilderMixin<T> mergeAll() {
    assert(isNotEmpty, 'There is nothing to merge.');
    return MergeRowBuilder<T>(this);
  }
}
