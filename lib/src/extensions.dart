import 'package:flutter/widgets.dart';

import 'arguments/table_row_build_arguments.dart';
import 'custom/builders/changeable_height_row_wrapper.dart';
import 'custom/builders/fixed_height_row_wrapper.dart';
import 'custom/builders/merge_row_builder.dart';
import 'custom/column/clickable_flexible_column.dart';
import 'custom/column/expanded_flexible_column.dart';
import 'custom/column/fixed_width_flexible_column.dart';
import 'custom/column/proportional_width_flexible_column.dart';
import 'flexible_column.dart';
import 'flexible_table_row_builder.dart';
import 'selectable/selectable_column.dart';
import 'sortable/sortable_column.dart';

extension AbsFlexibleColumnExt<T> on AbsFlexibleColumn<T> {
  AbsFlexibleColumn<T> withSort(int Function(T a, T b) compare) {
    return SortableColumn<T>(this, compareValue: compare);
  }

  AbsFlexibleColumn<T> withFixedWidth(double fixedWidth) {
    return FixedWidthFlexibleColumn<T>(this, fixedWidth: fixedWidth);
  }

  AbsFlexibleColumn<T> withProportionalWidth(double percent, {double omittedWidth = 0}) {
    return ProportionalWidthFlexibleColumn<T>(this, percent: percent, omittedWidth: omittedWidth);
  }

  AbsFlexibleColumn<T> withExpanded({int flex = 1, FlexFit fit = FlexFit.tight}) {
    return ExpandedFlexibleColumn<T>(this, flex: flex, fit: fit);
  }

  AbsFlexibleColumn<T> withHeaderClicked(
    void Function(TableHeaderRowBuildArguments<T> arguments) onClicked,
  ) {
    return ClickableHeaderColumn<T>(this, onHeaderClicked: onClicked);
  }

  AbsFlexibleColumn<T> withInfoClicked(
    void Function(TableInfoRowBuildArguments<T> arguments) onClicked,
  ) {
    return ClickableInfoColumn<T>(this, onInfoClicked: onClicked);
  }

  AbsFlexibleColumn<T> asSelectableColumn(AbsFlexibleColumn<T> unSelectableColumn) {
    return SelectableColumn<T>(selectableColumn: this, unSelectableColumn: unSelectableColumn);
  }

  AbsFlexibleColumn<T> asUnSelectableColumn(AbsFlexibleColumn<T> selectableColumn) {
    return SelectableColumn<T>(selectableColumn: selectableColumn, unSelectableColumn: this);
  }
}

extension TableRowBuilderExt<T> on FlexibleTableRowBuilderMixin<T> {
  FlexibleTableRowBuilderMixin<T> withHeightFixed({
    required double headerRowHeight,
    required double infoRowHeight,
  }) {
    return FixedHeightRowWrapper<T>(this, headerRowHeight: headerRowHeight, infoRowHeight: infoRowHeight);
  }

  FlexibleTableRowBuilderMixin<T> withHeightChangeable({
    required double Function(TableHeaderRowBuildArguments<T> arguments) headerRowHeight,
    required double Function(TableInfoRowBuildArguments<T> arguments) infoRowHeight,
  }) {
    return ChangeableHeightRowWrapper<T>(this, headerRowHeight: headerRowHeight, infoRowHeight: infoRowHeight);
  }

  FlexibleTableRowBuilderMixin<T> withInfoHeightChangeable(
    double headerRowHeight, {
    required double Function(TableInfoRowBuildArguments<T> arguments) infoRowHeight,
  }) {
    return ChangeableInfoHeightRowWrapper<T>(this, headerRowHeight: headerRowHeight, infoRowHeight: infoRowHeight);
  }
}

extension IterableTableRowBuilderExt<T> on Iterable<FlexibleTableRowBuilderMixin<T>> {
  FlexibleTableRowBuilderMixin<T> mergeAll() {
    return MergeRowBuilder<T>(this);
  }
}
