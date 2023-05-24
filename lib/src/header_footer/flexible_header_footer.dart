import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

///表列表头、尾布局配置
abstract class AbsFlexibleHeaderFooter<T> {
  const AbsFlexibleHeaderFooter();

  bool get hasHeader;

  bool get hasFooter;

  ///返回 null 表示不限制高度
  double? get fixedHeaderHeight;

  Widget? buildHeader(FlexibleTableController<T> controller, AbsFlexibleTableConfigurations<T> configurations);

  ///返回 null 表示不限制高度
  double? get fixedFooterHeight;

  Widget? buildFooter(FlexibleTableController<T> controller, AbsFlexibleTableConfigurations<T> configurations);
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
  bool get hasHeader => header != null;

  @override
  bool get hasFooter => footer != null;

  @override
  Widget? buildHeader(FlexibleTableController<T> controller, AbsFlexibleTableConfigurations<T> configurations) {
    return header;
  }

  @override
  Widget? buildFooter(FlexibleTableController<T> controller, AbsFlexibleTableConfigurations<T> configurations) {
    return footer;
  }
}
