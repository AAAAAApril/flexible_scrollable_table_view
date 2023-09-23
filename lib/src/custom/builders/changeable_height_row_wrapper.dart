import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flutter/widgets.dart';

///行高可变的行构造器
abstract class AbsChangeableHeightRowWrapper<T> with FlexibleTableRowBuilderMixin<T> {
  const AbsChangeableHeightRowWrapper(this._builder);

  final FlexibleTableRowBuilderMixin<T> _builder;

  ///获取表头行高
  @protected
  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments);

  ///获取表信息行高
  @protected
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments);

  @override
  Widget buildHeaderRow(TableHeaderRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      height: getHeaderRowHeight(arguments),
      child: _builder.buildHeaderRow(arguments),
    );
  }

  @override
  Widget buildInfoRow(TableInfoRowBuildArguments<T> arguments) {
    return SizedBox(
      width: arguments.parentWidth,
      height: getInfoRowHeight(arguments),
      child: _builder.buildInfoRow(arguments),
    );
  }
}

///表头和表信息行的高度都可变
final class ChangeableHeightRowWrapper<T> extends AbsChangeableHeightRowWrapper<T> {
  const ChangeableHeightRowWrapper(
    super.builder, {
    required this.headerRowHeight,
    required this.infoRowHeight,
  });

  final double Function(TableHeaderRowBuildArguments<T> arguments) headerRowHeight;
  final double Function(TableInfoRowBuildArguments<T> arguments) infoRowHeight;

  @override
  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments) {
    return headerRowHeight.call(arguments);
  }

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) {
    return infoRowHeight.call(arguments);
  }
}

///只有表信息行的高度可变
final class ChangeableInfoHeightRowWrapper<T> extends AbsChangeableHeightRowWrapper<T> {
  const ChangeableInfoHeightRowWrapper(
    super.builder, {
    required this.headerRowHeight,
    required this.infoRowHeight,
  });

  final double headerRowHeight;
  final double Function(TableInfoRowBuildArguments<T> arguments) infoRowHeight;

  @override
  double getHeaderRowHeight(TableHeaderRowBuildArguments<T> arguments) {
    return headerRowHeight;
  }

  @override
  double getInfoRowHeight(TableInfoRowBuildArguments<T> arguments) {
    return infoRowHeight.call(arguments);
  }
}

