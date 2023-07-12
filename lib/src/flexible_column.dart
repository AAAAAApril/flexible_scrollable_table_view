import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flutter/widgets.dart';

import 'animation/table_constraint_animation_wrapper.dart';

///列信息配置类
abstract class AbsFlexibleColumn<T> {
  const AbsFlexibleColumn(this.id);

  ///列 id，需要保持唯一
  final String id;

  ///该列的宽度
  AbsFlexibleTableColumnWidth get columnWidth;

  ///排序时会使用的回调（为 null 表示该列没有排序功能）
  Comparator<T>? get comparator => null;

  ///该列是否可比较
  bool get comparableColumn => comparator != null;

  ///构建列头组件
  Widget buildHeaderCellInternal(
    TableHeaderRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: BoxConstraints.tightFor(
        width: columnWidth.getColumnWidthByArguments(arguments),
        height: arguments.rowHeight,
      ),
      child: arguments.rowHeight <= 0 ? null : buildHeaderCell(arguments),
    );
  }

  ///构建列内容组件
  Widget buildInfoCellInternal(
    TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableAnimations<T>? animations,
  ) {
    return TableConstraintAnimationWrapper<T>(
      animations: animations,
      constraints: BoxConstraints.tightFor(
        width: columnWidth.getColumnWidthByArguments(arguments),
        height: arguments.rowHeight,
      ),
      child: arguments.rowHeight <= 0 ? null : buildInfoCell(arguments),
    );
  }

  ///构建表头
  @protected
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///构建表信息
  @protected
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AbsFlexibleColumn && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class FlexibleColumn<T> extends AbsFlexibleColumn<T> {
  const FlexibleColumn(
    super.id, {
    required this.columnWidth,
    this.header,
    this.headerBuilder,
    this.info,
    this.infoBuilder,
  });

  @override
  final AbsFlexibleTableColumnWidth<T> columnWidth;

  final Widget? header;
  final Widget Function(TableHeaderRowBuildArguments<T> arguments, AbsFlexibleColumn<T> column)? headerBuilder;

  final Widget? info;
  final Widget Function(TableInfoRowBuildArguments<T> arguments, AbsFlexibleColumn<T> column)? infoBuilder;

  @override
  Widget buildHeaderCell(TableHeaderRowBuildArguments<T> arguments) =>
      headerBuilder?.call(arguments, this) ?? header ?? const SizedBox.shrink();

  @override
  Widget buildInfoCell(TableInfoRowBuildArguments<T> arguments) =>
      infoBuilder?.call(arguments, this) ?? info ?? const SizedBox.shrink();
}
