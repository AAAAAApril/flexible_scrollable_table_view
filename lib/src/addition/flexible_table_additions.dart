import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flutter/widgets.dart';

typedef TableAdditionBuilder<T> = Widget Function(AbsTableBuildArguments<T> arguments);

///表内容区域附加组件
abstract class AbsFlexibleTableAdditions<T> {
  const AbsFlexibleTableAdditions();

  ///返回 null 表示不限制高度
  double? get fixedHeaderHeight;

  ///头部
  TableAdditionBuilder<T>? get headerBuilder;

  ///返回 null 表示不限制高度
  double? get fixedFooterHeight;

  ///尾部
  TableAdditionBuilder<T>? get footerBuilder;

  ///没有数据时的占位布局
  TableAdditionBuilder<T>? get placeholderBuilder;
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
  TableAdditionBuilder<T>? get headerBuilder => header == null ? null : (arguments) => header!;

  @override
  TableAdditionBuilder<T>? get footerBuilder => footer == null ? null : (arguments) => footer!;

  @override
  TableAdditionBuilder<T>? get placeholderBuilder => placeholder == null ? null : (arguments) => placeholder!;
}
