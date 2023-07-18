import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flutter/widgets.dart';

///表装饰配置
abstract class AbsFlexibleTableDecorations<T> {
  const AbsFlexibleTableDecorations();

  ///构建表头行装饰
  Widget buildTableHeaderRowDecorationWidget(
    TableHeaderRowBuildArguments<T> arguments,
    Widget headerRowWidget,
  );

  ///构建表信息行装饰
  Widget buildTableInfoRowDecorationWidget(
    TableInfoRowBuildArguments<T> arguments,
    Widget infoRowWidget,
  );
}

class FlexibleTableRowDecorations<T> extends AbsFlexibleTableDecorations<T> {
  const FlexibleTableRowDecorations({
    this.headerRowForeground,
    this.headerRowBackground,
    this.infoRowForeground,
    this.infoRowBackground,
  });

  factory FlexibleTableRowDecorations.infoArguments({
    Widget? headerRowForeground,
    Widget? headerRowBackground,
    Widget Function(TableInfoRowBuildArguments<T> arguments)? infoRowForeground,
    Widget Function(TableInfoRowBuildArguments<T> arguments)? infoRowBackground,
  }) =>
      _FlexibleTableRowDecorationsWithArguments<T>(
        headerRowForeground: headerRowForeground,
        headerRowBackground: headerRowBackground,
        infoRowForegroundWithArguments: infoRowForeground,
        infoRowBackgroundWithArguments: infoRowBackground,
      );

  final Widget? headerRowForeground;
  final Widget? headerRowBackground;

  final Widget? infoRowForeground;
  final Widget? infoRowBackground;

  @override
  Widget buildTableHeaderRowDecorationWidget(TableHeaderRowBuildArguments<T> arguments, Widget headerRowWidget) {
    return Stack(children: [
      if (headerRowBackground != null) Positioned.fill(child: headerRowBackground!),
      headerRowWidget,
      if (headerRowForeground != null) Positioned.fill(child: headerRowForeground!),
    ]);
  }

  @override
  Widget buildTableInfoRowDecorationWidget(TableInfoRowBuildArguments<T> arguments, Widget infoRowWidget) {
    return Stack(children: [
      if (infoRowBackground != null) Positioned.fill(child: infoRowBackground!),
      infoRowWidget,
      if (infoRowForeground != null) Positioned.fill(child: infoRowForeground!),
    ]);
  }
}

class _FlexibleTableRowDecorationsWithArguments<T> extends FlexibleTableRowDecorations<T> {
  const _FlexibleTableRowDecorationsWithArguments({
    super.headerRowForeground,
    super.headerRowBackground,
    this.infoRowForegroundWithArguments,
    this.infoRowBackgroundWithArguments,
  });

  final Widget Function(TableInfoRowBuildArguments<T> arguments)? infoRowForegroundWithArguments;
  final Widget Function(TableInfoRowBuildArguments<T> arguments)? infoRowBackgroundWithArguments;

  @override
  Widget buildTableInfoRowDecorationWidget(TableInfoRowBuildArguments<T> arguments, Widget infoRowWidget) {
    return Stack(children: [
      if (infoRowBackgroundWithArguments != null)
        Positioned.fill(
          child: infoRowBackgroundWithArguments!.call(arguments),
        ),
      infoRowWidget,
      if (infoRowForegroundWithArguments != null)
        Positioned.fill(
          child: infoRowForegroundWithArguments!.call(arguments),
        ),
    ]);
  }
}
