import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

typedef TableHeaderRowDecorationBuilder<T> = Widget Function(
  TableHeaderRowBuildArguments<T> arguments,
  Widget child,
);

typedef TableHeaderItemDecorationBuilder<T> = Widget Function(
  TableHeaderRowBuildArguments<T> arguments,
  AbsFlexibleColumn<T> column,
  Widget child,
);

typedef TableInfoRowDecorationBuilder<T> = Widget Function(
  TableInfoRowBuildArguments<T> arguments,
  Widget child,
);

typedef TableInfoItemDecorationBuilder<T> = Widget Function(
  TableInfoRowBuildArguments<T> arguments,
  AbsFlexibleColumn<T> column,
  Widget child,
);

///表装饰配置
abstract class AbsFlexibleTableDecorations<T> {
  const AbsFlexibleTableDecorations();

  ///构建表头行装饰
  TableHeaderRowDecorationBuilder<T>? get headerRowDecorationBuilder => null;

  ///构建表信息行装饰
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder => null;
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
  TableHeaderRowDecorationBuilder<T>? get headerRowDecorationBuilder =>
      (headerRowForeground == null && headerRowBackground == null)
          ? null
          : (arguments, child) => Stack(children: [
                if (headerRowBackground != null) Positioned.fill(child: headerRowBackground!),
                child,
                if (headerRowForeground != null) Positioned.fill(child: headerRowForeground!),
              ]);

  @override
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder =>
      (infoRowForeground == null && infoRowBackground == null)
          ? null
          : (arguments, child) => Stack(children: [
                if (infoRowBackground != null) Positioned.fill(child: infoRowBackground!),
                child,
                if (infoRowForeground != null) Positioned.fill(child: infoRowForeground!),
              ]);
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
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder =>
      (infoRowForegroundWithArguments == null && infoRowBackgroundWithArguments == null)
          ? null
          : (arguments, child) => Stack(children: [
                if (infoRowBackgroundWithArguments != null)
                  Positioned.fill(child: infoRowBackgroundWithArguments!.call(arguments)),
                child,
                if (infoRowForegroundWithArguments != null)
                  Positioned.fill(child: infoRowForegroundWithArguments!.call(arguments)),
              ]);
}
