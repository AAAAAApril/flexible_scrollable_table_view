import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

typedef TableHeaderRowDecorationBuilder<T> = Widget Function(
  FlexibleTableController<T> controller,
  AbsFlexibleTableConfigurations<T> configurations,
  Widget child,
);

typedef TableInfoRowDecorationBuilder<T> = Widget Function(
  FlexibleTableController<T> controller,
  AbsFlexibleTableConfigurations<T> configurations,
  int dataIndex,
  T data,
  Widget child,
);

///表装饰配置
abstract class AbsFlexibleTableDecorations<T> {
  const AbsFlexibleTableDecorations();

  ///构建表头行前景装饰
  TableHeaderRowDecorationBuilder<T>? get headerRowDecorationBuilder => null;

  ///构建表信息行装饰
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder => null;
}

class FlexibleTableDecorations<T> extends AbsFlexibleTableDecorations<T> {
  const FlexibleTableDecorations({
    this.headerForegroundRow,
    this.headerBackgroundRow,
    this.infoForegroundRow,
    this.infoBackgroundRow,
  });

  final Widget? headerForegroundRow;
  final Widget? headerBackgroundRow;

  final Widget? infoForegroundRow;
  final Widget? infoBackgroundRow;

  @override
  TableHeaderRowDecorationBuilder<T>? get headerRowDecorationBuilder =>
      (headerForegroundRow == null && headerBackgroundRow == null)
          ? null
          : (controller, configurations, child) => Stack(children: [
                if (headerBackgroundRow != null) Positioned.fill(child: headerBackgroundRow!),
                child,
                if (headerForegroundRow != null) Positioned.fill(child: headerForegroundRow!),
              ]);

  @override
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder =>
      (infoForegroundRow == null && infoBackgroundRow == null)
          ? null
          : (controller, configurations, dataIndex, data, child) => Stack(children: [
                if (infoBackgroundRow != null) Positioned.fill(child: infoBackgroundRow!),
                child,
                if (infoForegroundRow != null) Positioned.fill(child: infoForegroundRow!),
              ]);
}

class FlexibleTableDecorationsWithData<T> extends FlexibleTableDecorations<T> {
  const FlexibleTableDecorationsWithData({
    super.headerForegroundRow,
    super.headerBackgroundRow,
    this.infoForegroundRowWithData,
    this.infoBackgroundRowWithData,
  });

  final Widget Function(int dataIndex, T data)? infoForegroundRowWithData;
  final Widget Function(int dataIndex, T data)? infoBackgroundRowWithData;

  @override
  TableInfoRowDecorationBuilder<T>? get infoRowDecorationBuilder =>
      (infoForegroundRowWithData == null && infoBackgroundRowWithData == null)
          ? null
          : (controller, configurations, dataIndex, data, child) => Stack(children: [
                if (infoForegroundRowWithData != null)
                  Positioned.fill(
                    child: infoForegroundRowWithData!.call(dataIndex, data),
                  ),
                child,
                if (infoBackgroundRowWithData != null)
                  Positioned.fill(
                    child: infoBackgroundRowWithData!.call(dataIndex, data),
                  ),
              ]);
}
