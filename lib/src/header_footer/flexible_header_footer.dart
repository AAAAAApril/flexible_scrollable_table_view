import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

typedef TableHeaderFooterBuilder<T> = Widget Function(
  FlexibleTableController<T> controller,
  AbsFlexibleTableConfigurations<T> configurations,
);

///表列表头、尾布局配置
abstract class AbsFlexibleHeaderFooter<T> {
  const AbsFlexibleHeaderFooter();

  ///返回 null 表示不限制高度
  double? get fixedHeaderHeight;

  TableHeaderFooterBuilder<T>? get headerBuilder;

  ///返回 null 表示不限制高度
  double? get fixedFooterHeight;

  TableHeaderFooterBuilder<T>? get footerBuilder;
}

class FlexibleHeaderFooter<T> extends AbsFlexibleHeaderFooter<T> {
  const FlexibleHeaderFooter({
    this.fixedHeaderHeight,
    this.fixedFooterHeight,
    this.header,
    this.footer,
  });

  @override
  final double? fixedHeaderHeight;

  @override
  final double? fixedFooterHeight;

  final Widget? header;
  final Widget? footer;

  @override
  TableHeaderFooterBuilder<T>? get headerBuilder => header == null ? null : (controller, configurations) => header!;

  @override
  TableHeaderFooterBuilder<T>? get footerBuilder => footer == null ? null : (controller, configurations) => footer!;
}
