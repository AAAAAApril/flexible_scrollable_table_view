import 'package:flutter/widgets.dart';

import 'arguments/table_build_arguments.dart';
import 'custom/builders/appoint_height_row_builder.dart';
import 'custom/builders/decoration_row_builder.dart';
import 'custom/builders/divider_row_builder.dart';
import 'custom/builders/merge_row_builder.dart';
import 'custom/builders/pressable_row_builder.dart';
import 'custom/builders/scalable_row_builder.dart';
import 'custom/builders/stacked_row_builder.dart';
import 'custom/column/appoint_width_flexible_column.dart';
import 'custom/column/pressable_flexible_column.dart';
import 'custom/column/stacked_flexible_column.dart';
import 'flexible_table_column.dart';
import 'flexible_table_row_builder.dart';
import 'selectable/selectable_column.dart';
import 'sortable/sortable_table_column.dart';

extension AbsFlexibleTableColumnExt<T> on AbsFlexibleTableColumn<T> {
  AbsFlexibleTableColumn<T> withSortByPressColumnHeader(
    int Function(SortableTableColumnMixin<T> column, T a, T b) compare,
  ) {
    return SortableTableColumn<T>(this, compareValue: compare);
  }

  AbsFlexibleTableColumn<T> appointWidth(AppointedColumnWidth<T> width) {
    return AppointWidthFlexibleColumn<T>(this, width: width);
  }

  AbsFlexibleTableColumn<T> withStacks({
    Iterable<AbsFlexibleTableColumn<T>>? above,
    Iterable<AbsFlexibleTableColumn<T>>? below,
  }) {
    if ((above == null || above.isEmpty) && (below == null || below.isEmpty)) {
      return this;
    }
    return StackedFlexibleColumn<T>(this, above: above, below: below);
  }

  AbsFlexibleTableColumn<T> whenHeaderClicked(
    void Function(
      AbsFlexibleTableColumn<T> column,
      TableBuildArgumentsMixin<T> arguments,
      BuildContext context,
    ) onClicked, {
    bool expandPressArea = false,
  }) {
    return HeaderPressableColumn<T>(this, onHeaderClicked: onClicked, expandPressArea: expandPressArea);
  }

  AbsFlexibleTableColumn<T> whenInfoClicked(
    void Function(
      AbsFlexibleTableColumn<T> column,
      TableInfoRowArgumentsMixin<T> arguments,
      BuildContext context,
    ) onClicked, {
    bool expandPressArea = false,
  }) {
    return InfoPressableColumn<T>(this, onInfoClicked: onClicked, expandPressArea: expandPressArea);
  }

  AbsFlexibleTableColumn<T> asSelectableColumn(AbsFlexibleTableColumn<T> unSelectableColumn) {
    return SelectableColumn<T>(selectableColumn: this, unSelectableColumn: unSelectableColumn);
  }

  AbsFlexibleTableColumn<T> asUnSelectableColumn(AbsFlexibleTableColumn<T> selectableColumn) {
    return SelectableColumn<T>(selectableColumn: selectableColumn, unSelectableColumn: this);
  }

  ScalableTableColumn<T> withScalableWith(
    KnownColumnWidthMixin<T> knownWidth, {
    AppointedColumnWidth<T>? unKnownWidth,
  }) {
    return ScalableTableColumn<T>(this, knownWidth: knownWidth, unKnownWidth: unKnownWidth);
  }
}

extension TableRowBuilderExt<T> on FlexibleTableRowBuilderMixin<T> {
  FlexibleTableRowBuilderMixin<T> appointHeight(AppointedRowHeight<T> height) {
    return AppointHeightRowBuilder<T>(this, height: height);
  }

  FlexibleTableRowBuilderMixin<T> withDivider({
    bool aroundHeaderRow = false,
    bool outsideOfRowItem = false,
  }) {
    return DividerRowBuilder<T>(this, aroundHeaderRow: aroundHeaderRow, outsideOfRowItem: outsideOfRowItem);
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

  FlexibleTableRowBuilderMixin<T> withDecoration({
    DecorationPosition position = DecorationPosition.background,
    Decoration Function(TableBuildArgumentsMixin<T> arguments)? headerRowDecoration,
    Decoration Function(TableInfoRowArgumentsMixin<T> arguments)? infoRowDecoration,
  }) {
    return DecorationRowBuilder<T>(
      this,
      position: position,
      headerRowDecoration: headerRowDecoration,
      infoRowDecoration: infoRowDecoration,
    );
  }

  FlexibleTableRowBuilderMixin<T> whenPressed({
    void Function(TableInfoRowArgumentsMixin<T> arguments, BuildContext context)? onPressed,
    void Function(TableInfoRowArgumentsMixin<T> arguments, BuildContext context)? onLongPressed,
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
