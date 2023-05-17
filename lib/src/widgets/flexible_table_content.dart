import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decoration.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flutter/widgets.dart';

import 'flexible_table_info_row.dart';

///表内容区域
class FlexibleTableContent<T> extends StatelessWidget {
  const FlexibleTableContent(
    this.controller, {
    super.key,
    required this.configurations,
    this.foregroundRowDecoration,
    this.backgroundRowDecoration,
    this.verticalScrollController,
    this.shrinkWrap = false,
    this.primary,
    this.physics,
    this.disableVerticalScroll = false,
    this.footer,
  });

  final FlexibleTableController<T> controller;
  final FlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableRowDecoration<T>? foregroundRowDecoration;
  final AbsFlexibleTableRowDecoration<T>? backgroundRowDecoration;
  final ScrollController? verticalScrollController;
  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool disableVerticalScroll;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    double? itemExtent;
    if (configurations.infoRowHeightBuilder == null) {
      itemExtent = configurations.infoRowHeight;
    }
    Widget child = ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => ListView.builder(
        controller: verticalScrollController,
        itemCount: value.length + (footer != null ? 1 : 0),
        shrinkWrap: shrinkWrap,
        primary: primary,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemExtent: itemExtent,
        physics: physics,
        itemBuilder: (context, index) {
          if (index == value.length) {
            return footer;
          }
          return FlexibleTableInfoRow<T>(
            controller,
            configurations: configurations,
            dataIndex: index,
            data: value[index],
            foregroundDecoration: foregroundRowDecoration,
            backgroundDecoration: backgroundRowDecoration,
          );
        },
      ),
    );
    if (disableVerticalScroll) {
      return child;
    }
    return LayoutBuilder(
      builder: (p0, p1) => SizedBox.fromSize(
        size: Size(p1.maxWidth, p1.maxHeight),
        child: child,
      ),
    );
  }
}
