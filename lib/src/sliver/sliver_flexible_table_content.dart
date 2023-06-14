import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/widgets/flexible_table_content.dart';
import 'package:flutter/widgets.dart';

/// Sliver 型 表内容区域
class SliverFlexibleTableContent<T> extends FlexibleTableContent<T> {
  const SliverFlexibleTableContent(
    super.controller, {
    super.key,
    required super.configurations,
    super.additions,
    super.decorations,
    super.animations,
  });

  @override
  Widget build(BuildContext context) {
    final AbsTableBuildArguments<T> arguments = TableBuildArguments<T>(
      controller,
      configurations,
    );
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
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
            rowWidth: null,
          ),
          childCount: totalItemCount,
        );
        if (itemExtent == null) {
          return SliverList(delegate: delegate);
        }
        return SliverFixedExtentList(delegate: delegate, itemExtent: itemExtent);
      },
    );
  }
}
