import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_sliver_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/widgets/flexible_table_content.dart';
import 'package:flutter/widgets.dart';

/// Sliver 型 表内容区域
class SliverFlexibleTableContent<T> extends FlexibleTableContent<T> {
  const SliverFlexibleTableContent(
    super.dataSource, {
    super.key,
    required super.configurations,
    required super.horizontalScrollMixin,
    super.additions,
    super.decorations,
    super.animations,
    super.horizontalPhysics,
  });

  @override
  Widget build(BuildContext context) {
    return LazySliverLayoutBuilder(
      builder: (context, parentWidth) {
        final AbsTableBuildArguments<T> arguments = TableBuildArguments<T>(
          dataSource: dataSource,
          horizontalScrollMixin: horizontalScrollMixin,
          configurations: configurations,
          parentWidth: parentWidth,
        );
        return ValueListenableBuilder<List<T>>(
          valueListenable: dataSource,
          builder: (context, value, child) {
            final double? itemExtent = value.isEmpty ? null : super.itemExtent;
            final int totalItemCount = getItemCount(value);
            final SliverChildDelegate delegate = SliverChildBuilderDelegate(
              (context, index) => buildItem(
                context,
                arguments: arguments,
                value: value,
                index: index,
                itemCount: totalItemCount,
              ),
              childCount: totalItemCount,
            );
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
