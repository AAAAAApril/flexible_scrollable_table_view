import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///约定高度的行
final class AppointHeightRowBuilder<T> with FlexibleTableRowBuilderMixin<T> {
  const AppointHeightRowBuilder(
    this._builder, {
    required this.height,
  });

  final FlexibleTableRowBuilderMixin<T> _builder;
  final AppointedRowHeight height;

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return height.constrainHeaderRowHeight(arguments, _builder.buildHeaderRow(arguments));
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return height.constrainInfoRowHeight(arguments, _builder.buildInfoRow(arguments));
  }
}

abstract class AppointedRowHeight<T> {
  const AppointedRowHeight();

  ///约束表头行高度
  Widget constrainHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments, Widget rowWidget);

  ///约束表信息行高度
  Widget constrainInfoRowHeight(TableInfoRowBuildArguments<T> arguments, Widget rowWidget);
}

///固定的行高
final class FixedRowHeight<T> extends AppointedRowHeight<T> {
  const FixedRowHeight({
    required this.headerHeight,
    required this.infoHeight,
  });

  final double headerHeight;
  final double infoHeight;

  @override
  Widget constrainHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: headerHeight, child: rowWidget);
  }

  @override
  Widget constrainInfoRowHeight(TableInfoRowBuildArguments<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: infoHeight, child: rowWidget);
  }
}

///每次重新构建行时都可以改变行高
abstract class AbsChangeableRowHeight<T> extends AppointedRowHeight<T> {
  const AbsChangeableRowHeight();

  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments);

  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments);

  @override
  Widget constrainHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: getHeaderRowHeight(arguments), child: rowWidget);
  }

  @override
  Widget constrainInfoRowHeight(TableInfoRowBuildArguments<T> arguments, Widget rowWidget) {
    return SizedBox(width: arguments.parentWidth, height: getInfoRowHeight(arguments), child: rowWidget);
  }
}

final class ChangeableRowHeight<T> extends AbsChangeableRowHeight<T> {
  const ChangeableRowHeight({
    required this.headerHeight,
    required this.infoHeight,
  });

  final double Function(TableHeaderRowBuildArguments<T> arguments) headerHeight;
  final double Function(TableInfoRowBuildArguments<T> arguments) infoHeight;

  @override
  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments) => headerHeight.call(arguments);

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) => infoHeight.call(arguments);
}

///固定表头行高度，表信息行高度可以在每次重新构建时改变
final class FixedHeaderRowHeight<T> extends AbsChangeableRowHeight<T> {
  const FixedHeaderRowHeight(
    this.headerHeight, {
    required this.infoHeight,
  });

  final double headerHeight;
  final double Function(TableInfoRowBuildArguments<T> arguments) infoHeight;

  @override
  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments) => headerHeight;

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) => infoHeight.call(arguments);
}
