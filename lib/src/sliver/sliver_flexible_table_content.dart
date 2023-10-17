import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/custom/widgets/lazy_sliver_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/widgets/flexible_table_content.dart';
import 'package:flutter/widgets.dart';

/// Sliver 型 表内容区域
class SliverFlexibleTableContent<T> extends FlexibleTableContent<T> {
  const SliverFlexibleTableContent(
    super.dataSource, {
    super.key,
    required super.rowBuilder,
    super.listHeaderBuilder,
    super.listFooterBuilder,
    super.listPlaceholderBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LazySliverLayoutBuilder(
      builder: (context, parentWidth) {
        final TableBuildArgumentsMixin<T> arguments = TableBuildArguments<T>(
          dataSource: dataSource,
          parentWidth: parentWidth,
        );
        return ValueListenableBuilder<List<T>>(
          valueListenable: dataSource,
          builder: (context, value, child) {
            final int totalItemCount = getItemCount(value);
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => buildItem(
                  context,
                  arguments: arguments,
                  value: value,
                  index: index,
                  itemCount: totalItemCount,
                ),
                childCount: totalItemCount,
              ),
            );
          },
        );
      },
    );
  }
}
