import 'package:flexible_scrollable_table_view/src/addition/flexible_table_additions.dart';
import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/sliver/sliver_flexible_table_content.dart';
import 'package:flutter/widgets.dart';

import 'flexible_table_info_row.dart';

///表内容区域
class FlexibleTableContent<T> extends StatelessWidget {
  const FlexibleTableContent(
    this.controller, {
    super.key,
    required this.configurations,
    this.additions,
    this.decorations,
    this.animations,
    this.verticalScrollController,
    this.shrinkWrap = false,
    this.primary,
    this.verticalPhysics,
    this.horizontalPhysics,
  });

  factory FlexibleTableContent.sliver(
    FlexibleTableController<T> controller, {
    Key? key,
    required AbsFlexibleTableConfigurations<T> configurations,
    AbsFlexibleTableAdditions<T>? additions,
    AbsFlexibleTableDecorations<T>? decorations,
    AbsFlexibleTableAnimations<T>? animations,
  }) =>
      SliverFlexibleTableContent<T>(
        controller,
        key: key,
        configurations: configurations,
        additions: additions,
        decorations: decorations,
        animations: animations,
      );

  final FlexibleTableController<T> controller;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableAdditions<T>? additions;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;

  final ScrollController? verticalScrollController;

  final bool shrinkWrap;
  final bool? primary;
  final ScrollPhysics? verticalPhysics;
  final ScrollPhysics? horizontalPhysics;

  bool get hasHeader => additions?.headerBuilder != null;

  bool get hasFooter => additions?.footerBuilder != null;

  bool get hasPlaceholder => additions?.placeholderBuilder != null;

  @protected
  int getItemCount(List<T> dataList) {
    //当数据列是空的
    if (dataList.isEmpty) {
      //需要显示占位符，则返回 有 1 条数据，否则为 0 条。
      return hasPlaceholder ? 1 : 0;
    }
    //数据列不为空，数据总条数 = 头 + 数据列 + 尾
    return (hasHeader ? 1 : 0) + dataList.length + (hasFooter ? 1 : 0);
  }

  @protected
  bool isHeaderIndex(int index) {
    //当下标为 0，并且又有头部的时候，则当前下标为头部
    return index == 0 && hasHeader;
  }

  @protected
  bool isFooterIndex(List<T> value, int index) {
    //当下标 = 数据长度 + 头部数量，则当前下标为尾部
    return index == value.length + (hasHeader ? 1 : 0);
  }

  @protected
  int realDataIndex(int index) {
    //真实的数据下标 = 列表下标 - 头部数量
    return index - (hasHeader ? 1 : 0);
  }

  @protected
  Widget buildItem(
    BuildContext context, {
    required AbsTableBuildArguments<T> arguments,
    required List<T> value,
    required int index,
    required int itemCount,
  }) {
    //数据是空的，却又需要构建列表项，说明是需要绘制占位组件
    if (value.isEmpty && hasPlaceholder) {
      return additions!.placeholderBuilder!.call(arguments);
    }
    if (isHeaderIndex(index)) {
      return additions!.headerBuilder!.call(arguments);
    }
    if (isFooterIndex(value, index)) {
      return additions!.footerBuilder!.call(arguments);
    }
    return FlexibleTableInfoRow<T>(
      arguments.toInfoRowArguments(
        dataIndex: realDataIndex(index),
        dataList: value,
        currentItemIndex: index,
        totalItemCount: itemCount,
      ),
      decorations: decorations,
      animations: animations,
      physics: horizontalPhysics,
    );
  }

  @protected
  double? get itemExtent {
    if (configurations.rowHeight.infoRowHeightBuilder != null || configurations.rowHeight.fixedInfoRowHeight == null) {
      return null;
    }
    if (hasHeader) {
      if (additions!.fixedHeaderHeight != configurations.rowHeight.fixedInfoRowHeight) {
        return null;
      }
    }
    if (hasFooter) {
      if (additions!.fixedFooterHeight != configurations.rowHeight.fixedInfoRowHeight) {
        return null;
      }
    }
    return configurations.rowHeight.fixedInfoRowHeight;
  }

  @override
  Widget build(BuildContext context) {
    return LazyLayoutBuilder(
      builder: (context, constraints) {
        final AbsTableBuildArguments<T> arguments = TableBuildArguments<T>(
          controller,
          configurations,
          constraints.maxWidth,
        );
        final Widget child = ValueListenableBuilder<List<T>>(
          valueListenable: controller,
          builder: (context, value, child) {
            final int totalItemCount = getItemCount(value);
            return ListView.builder(
              controller: verticalScrollController,
              itemCount: totalItemCount,
              shrinkWrap: shrinkWrap,
              primary: primary,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemExtent: value.isEmpty ? null : itemExtent,
              physics: verticalPhysics,
              itemBuilder: (context, index) => buildItem(
                context,
                arguments: arguments,
                value: value,
                index: index,
                itemCount: totalItemCount,
              ),
            );
          },
        );
        if (shrinkWrap) {
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
