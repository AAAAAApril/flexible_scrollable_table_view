import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

typedef TableHeaderFooterBuilder<T> = Widget Function(
  FlexibleTableController<T> controller,
  AbsFlexibleTableConfigurations<T> configurations,
);

typedef TablePlaceholderBuilder<T> = Widget Function(
  FlexibleTableController<T> controller,
  AbsFlexibleTableConfigurations<T> configurations,
  double viewportWidth,
);

///表内容区域附加组件
abstract class AbsFlexibleTableAdditions<T> {
  const AbsFlexibleTableAdditions();

  ///返回 null 表示不限制高度
  double? get fixedHeaderHeight;

  ///头部
  TableHeaderFooterBuilder<T>? get headerBuilder;

  ///返回 null 表示不限制高度
  double? get fixedFooterHeight;

  ///尾部
  TableHeaderFooterBuilder<T>? get footerBuilder;

  ///没有数据时的占位布局
  TablePlaceholderBuilder<T>? get placeholderBuilder;
}

class FlexibleTableAdditions<T> extends AbsFlexibleTableAdditions<T> {
  const FlexibleTableAdditions({
    this.fixedHeaderHeight,
    this.fixedFooterHeight,
    this.header,
    this.footer,
    this.placeholder,
  });

  @override
  final double? fixedHeaderHeight;

  @override
  final double? fixedFooterHeight;

  final Widget? header;
  final Widget? footer;
  final Widget? placeholder;

  @override
  TableHeaderFooterBuilder<T>? get headerBuilder => header == null ? null : (controller, configurations) => header!;

  @override
  TableHeaderFooterBuilder<T>? get footerBuilder => footer == null ? null : (controller, configurations) => footer!;

  @override
  TablePlaceholderBuilder<T>? get placeholderBuilder =>
      placeholder == null ? null : (controller, configurations, viewportWidth) => placeholder!;
}
