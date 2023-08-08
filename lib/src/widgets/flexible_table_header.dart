import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flutter/widgets.dart';

///表头（行）
class FlexibleTableHeader<T> extends StatelessWidget {
  const FlexibleTableHeader(
    this.dataSource, {
    super.key,
    required this.configurations,
    required this.horizontalScrollMixin,
    this.decorations,
    this.animations,
    this.physics,
  });

  final FlexibleTableDataSource<T> dataSource;
  final AbsFlexibleTableConfigurations<T> configurations;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final TableHorizontalScrollMixin horizontalScrollMixin;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LazyLayoutBuilder(
      builder: (context, constraints) => configurations.buildTableHeaderRow(
        arguments: TableHeaderRowBuildArguments<T>(
          dataSource: dataSource,
          horizontalScrollMixin: horizontalScrollMixin,
          configurations: configurations,
          parentWidth: constraints.maxWidth,
        ),
        decorations: decorations,
        animations: animations,
        physics: physics,
      ),
    );
  }
}
