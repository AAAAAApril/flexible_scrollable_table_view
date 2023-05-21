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
    this.header,
    this.headerFixedHeight,
    this.footer,
    this.footerFixedHeight,
  });

  factory FlexibleTableContent.sliver(
    FlexibleTableController<T> controller, {
    Key? key,
    required AbsFlexibleTableConfigurations<T> configurations,
    AbsFlexibleTableDecorations<T>? decorations,
    Widget? header,
    double? headerFixedHeight,
    Widget? footer,
    double? footerFixedHeight,
  }) =>
      _SliverFlexibleTableContent<T>(
        controller,
        key: key,
        configurations: configurations,
        decorations: decorations,
        header: header,
        headerFixedHeight: headerFixedHeight,
        footer: footer,
        footerFixedHeight: footerFixedHeight,
      );

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;

  final ScrollController? verticalScrollController;

  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;

  final bool verticalScrollable;

  final Widget? header;
  final double? headerFixedHeight;
  final Widget? footer;
  final double? footerFixedHeight;

  double? get itemExtent {
    if (configurations.infoRowHeightBuilder != null) {
      return null;
    }
    if (header != null && headerFixedHeight != configurations.infoRowHeight) {
      return null;
    }
    if (footer != null && footerFixedHeight != configurations.infoRowHeight) {
      return null;
    }
    return configurations.infoRowHeight;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => ListView.builder(
        controller: verticalScrollController,
        itemCount: (header != null ? 1 : 0) + value.length + (footer != null ? 1 : 0),
        shrinkWrap: shrinkWrap,
        primary: primary,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemExtent: itemExtent,
        physics: !verticalScrollable ? const NeverScrollableScrollPhysics() : physics,
        itemBuilder: (context, index) {
          if (index == 0 && header != null) {
            return header!;
          }
          if (index == value.length + (header != null ? 1 : 0)) {
            return footer!;
          }
          final int dataIndex = index - (header != null ? 1 : 0);
          return FlexibleTableInfoRow<T>(
            controller,
            configurations: configurations,
            dataIndex: dataIndex,
            data: value[dataIndex],
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
    super.header,
    super.headerFixedHeight,
    super.footer,
    super.footerFixedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) {
        final SliverChildDelegate delegate = SliverChildBuilderDelegate(
          (context, index) {
            if (index == 0 && header != null) {
              return header!;
            }
            if (index == value.length + (header != null ? 1 : 0)) {
              return footer!;
            }
            final int dataIndex = index - (header != null ? 1 : 0);
            return FlexibleTableInfoRow<T>(
              controller,
              configurations: configurations,
              dataIndex: dataIndex,
              data: value[dataIndex],
              decorations: decorations,
            );
          },
          childCount: (header != null ? 1 : 0) + value.length + (footer != null ? 1 : 0),
        );
        final double? itemExtent = super.itemExtent;
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
