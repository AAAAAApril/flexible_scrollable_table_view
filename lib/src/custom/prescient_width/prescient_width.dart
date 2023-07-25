import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_column_width.dart';
import 'package:flexible_scrollable_table_view/src/custom/prescient_width/prescient_width_group.dart';

mixin PrescientWidthMixin<T> on AbsFlexibleTableColumnWidth<T> {
  PrescientWidthGroup get widthGroup;

  ///获取列头项的宽度
  double getColumnWidthOfHeaderCell(TableHeaderRowBuildArguments<T> arguments);

  ///获取列信息项的宽度
  double getColumnWidthOfInfoCell(TableInfoRowBuildArguments<T> arguments);

  @override
  double getColumnWidth(AbsTableBuildArguments<T> arguments) {
    throw Exception('Instance of AbsPrescientWidth<T> only used in PrescientWidthColumnMixin<T> .');
  }
}

class PrescientWidth<T> extends AbsFlexibleTableColumnWidth<T> with PrescientWidthMixin<T> {
  PrescientWidth({
    required this.headerCellWidth,
    required this.infoCellWidth,
  });

  final double Function(TableHeaderRowBuildArguments<T> arguments) headerCellWidth;
  final double Function(TableInfoRowBuildArguments<T> arguments) infoCellWidth;

  @override
  double getColumnWidthOfHeaderCell(TableHeaderRowBuildArguments<T> arguments) => headerCellWidth.call(arguments);

  @override
  double getColumnWidthOfInfoCell(TableInfoRowBuildArguments<T> arguments) => infoCellWidth.call(arguments);

  @override
  late final PrescientWidthGroup widthGroup = PrescientWidthGroup();

  void dispose() {
    widthGroup.dispose();
  }
}
