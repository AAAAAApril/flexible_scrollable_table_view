import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/header_footer/flexible_header_footer.dart';
import 'package:flutter/widgets.dart';

import 'flexible_table_info_row.dart';

///表内容区域
class FlexibleTableContent<T> extends StatelessWidget {
  const FlexibleTableContent(
    this.controller, {
    super.key,
    required this.configurations,
    this.headerFooter,
    this.decorations,
    this.animations,
    this.verticalScrollController,
    this.shrinkWrap = false,
    this.primary,
    this.physics,
    this.verticalScrollable = true,
  });

  factory FlexibleTableContent.sliver(
    FlexibleTableController<T> controller, {
    Key? key,
    required AbsFlexibleTableConfigurations<T> configurations,
    AbsFlexibleHeaderFooter<T>? headerFooter,
    AbsFlexibleTableDecorations<T>? decorations,
    AbsFlexibleTableAnimations<T>? animations,
  }) =>
      SliverFlexibleTableContent<T>(
        controller,
        key: key,
        configurations: configurations,
        headerFooter: headerFooter,
        decorations: decorations,
        animations: animations,
      );

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleHeaderFooter<T>? headerFooter;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;

  final ScrollController? verticalScrollController;

  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? physics;

  final bool verticalScrollable;

  bool get hasHeader => headerFooter?.headerBuilder != null;

  bool get hasFooter => headerFooter?.footerBuilder != null;

  int getItemCount(List<T> dataList) {
    return (hasHeader ? 1 : 0) + dataList.length + (hasFooter ? 1 : 0);
  }

  bool isHeaderIndex(int index) {
    return index == 0 && hasHeader;
  }

  bool isFooterIndex(List<T> value, int index) {
    return index == value.length + (hasHeader ? 1 : 0);
  }

  int realDataIndex(int index) {
    return index - (hasHeader ? 1 : 0);
  }

  Widget buildItem(
    BuildContext context, {
    required double rowWidth,
    required List<T> value,
    required int index,
  }) {
    if (isHeaderIndex(index)) {
      return headerFooter!.headerBuilder!.call(controller, configurations);
    }
    if (isFooterIndex(value, index)) {
      return headerFooter!.footerBuilder!.call(controller, configurations);
    }
    final int dataIndex = realDataIndex(index);
    return FlexibleTableInfoRow<T>(
      controller,
      configurations: configurations,
      dataIndex: dataIndex,
      data: value[dataIndex],
      decorations: decorations,
      animations: animations,
      rowWidth: rowWidth,
    );
  }

  double? get itemExtent {
    if (configurations.infoRowHeightBuilder != null) {
      return null;
    }
    if (hasHeader) {
      if (headerFooter!.fixedHeaderHeight != configurations.infoRowHeight) {
        return null;
      }
    }
    if (hasFooter) {
      if (headerFooter!.fixedFooterHeight != configurations.infoRowHeight) {
        return null;
      }
    }
    return configurations.infoRowHeight;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget child = ValueListenableBuilder<List<T>>(
          valueListenable: controller,
          builder: (context, value, child) => ListView.builder(
            controller: verticalScrollController,
            itemCount: getItemCount(value),
            shrinkWrap: shrinkWrap,
            primary: primary,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemExtent: itemExtent,
            physics: !verticalScrollable ? const NeverScrollableScrollPhysics() : physics,
            itemBuilder: (context, index) => buildItem(
              context,
              rowWidth: constraints.maxWidth,
              value: value,
              index: index,
            ),
          ),
        );
        if (!verticalScrollable) {
          return SizedBox(
            width: constraints.maxWidth,
            child: child,
          );
        }
        return ConstrainedBox(
          constraints: BoxConstraints.tight(
            Size(constraints.maxWidth, constraints.maxHeight),
          ),
          child: child,
        );
      },
    );
  }
}

class SliverFlexibleTableContent<T> extends FlexibleTableContent<T> {
  const SliverFlexibleTableContent(
    super.controller, {
    super.key,
    required super.configurations,
    super.headerFooter,
    super.decorations,
    super.animations,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder<List<T>>(
          valueListenable: controller,
          builder: (context, value, child) {
            final SliverChildDelegate delegate = SliverChildBuilderDelegate(
              (context, index) => buildItem(
                context,
                rowWidth: constraints.crossAxisExtent,
                value: value,
                index: index,
              ),
              childCount: getItemCount(value),
            );
            final double? itemExtent = super.itemExtent;
            if (itemExtent == null) {
              return SliverList(delegate: delegate);
            }
            return SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent);
          },
        );
      },
    );
  }
}
