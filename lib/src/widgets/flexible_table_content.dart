import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
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
    this.decorations,
    this.verticalScrollController,
    this.shrinkWrap = false,
    this.primary,
    this.physics,
    this.verticalScrollable = true,
    this.footer,
    this.fixedExtent = true,
  });

  factory FlexibleTableContent.sliver(
    FlexibleTableController<T> controller, {
    Key? key,
    required AbsFlexibleTableConfigurations<T> configurations,
    AbsFlexibleTableDecorations<T>? decorations,
    Widget? footer,
    bool fixedExtent = true,
  }) =>
      _SliverFlexibleTableContent<T>(
        controller,
        key: key,
        configurations: configurations,
        decorations: decorations,
        footer: footer,
        fixedExtent: fixedExtent,
      );

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final ScrollController? verticalScrollController;
  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool verticalScrollable;
  final Widget? footer;
  final bool fixedExtent;

  @override
  Widget build(BuildContext context) {
    double? itemExtent;
    if (fixedExtent && footer == null && configurations.infoRowHeightBuilder == null) {
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
        physics: !verticalScrollable ? const NeverScrollableScrollPhysics() : physics,
        itemBuilder: (context, index) {
          if (index == value.length) {
            return footer!;
          }
          return FlexibleTableInfoRow<T>(
            controller,
            configurations: configurations,
            dataIndex: index,
            data: value[index],
            decorations: decorations,
          );
        },
      ),
    );
    if (!verticalScrollable) {
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

class _SliverFlexibleTableContent<T> extends FlexibleTableContent<T> {
  const _SliverFlexibleTableContent(
    super.controller, {
    super.key,
    required super.configurations,
    super.decorations,
    super.footer,
    super.fixedExtent,
  });

  @override
  Widget build(BuildContext context) {
    double? itemExtent;
    if (fixedExtent && footer == null && configurations.infoRowHeightBuilder == null) {
      itemExtent = configurations.infoRowHeight;
    }
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) {
        final SliverChildDelegate delegate = SliverChildBuilderDelegate(
          (context, index) {
            if (index == value.length) {
              return footer!;
            }
            return FlexibleTableInfoRow<T>(
              controller,
              configurations: configurations,
              dataIndex: index,
              data: value[index],
              decorations: decorations,
            );
          },
          childCount: value.length + (footer != null ? 1 : 0),
        );
        if (itemExtent == null) {
          return SliverList(delegate: delegate);
        }
        return SliverFixedExtentList(
          delegate: delegate,
          itemExtent: itemExtent,
        );
      },
    );
  }
}
