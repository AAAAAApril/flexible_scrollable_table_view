import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_row_builder.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/layout_builder/lazy_layout_builder.dart';
import 'package:flutter/widgets.dart';

///表头（行）
class FlexibleTableHeader<T> extends StatelessWidget {
  const FlexibleTableHeader(
    this.dataSource, {
    super.key,
    required this.rowBuilder,
  });

  final FlexibleTableDataSource<T> dataSource;
  final FlexibleTableRowBuilderMixin<T> rowBuilder;

  @override
  Widget build(BuildContext context) {
    return LazyLayoutBuilder(
      builder: (context, constraints) => rowBuilder.buildHeaderRow(
        TableHeaderRowBuildArguments<T>(
          dataSource: dataSource,
          parentWidth: constraints.maxWidth,
        ),
      ),
    );
  }
}
