import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_row_height.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/row/table_header_row_build_mixin.dart';
import 'package:flexible_scrollable_table_view/src/row/table_info_row_build_mixin.dart';

///表配置
abstract class AbsFlexibleTableConfigurations<T>
    implements TableHeaderRowBuildInterface<T>, TableInfoRowBuildInterface<T> {
  const AbsFlexibleTableConfigurations();

  ///表行高
  AbsFlexibleTableRowHeight<T> get rowHeight;

  ///不能左右滑动的列（会堆积在左侧）
  Set<AbsFlexibleColumn<T>> get leftPinnedColumns;

  ///不能左右滑动的列（会堆积在右侧）
  Set<AbsFlexibleColumn<T>> get rightPinnedColumns;

  ///可以左右滑动的列
  Set<AbsFlexibleColumn<T>> get scrollableColumns;

  ///根据 列 id 查找 列实例
  AbsFlexibleColumn<T>? findColumnById(String columnId) {
    if (leftPinnedColumns.isEmpty && rightPinnedColumns.isEmpty && scrollableColumns.isEmpty) {
      return null;
    }
    for (final element in Set<AbsFlexibleColumn<T>>.of(leftPinnedColumns)
      ..addAll(rightPinnedColumns)
      ..addAll(scrollableColumns)) {
      if (element.id == columnId) {
        return element;
      }
    }
    return null;
  }
}

class FlexibleTableConfigurations<T> extends AbsFlexibleTableConfigurations<T>
    with TableHeaderRowBuildMixin<T>, TableInfoRowBuildMixin<T> {
  FlexibleTableConfigurations({
    required this.rowHeight,
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  })  : leftPinnedColumns = leftPinnedColumns ?? <AbsFlexibleColumn<T>>{},
        rightPinnedColumns = rightPinnedColumns ?? <AbsFlexibleColumn<T>>{},
        scrollableColumns = scrollableColumns ?? <AbsFlexibleColumn<T>>{};

  @override
  final AbsFlexibleTableRowHeight<T> rowHeight;

  @override
  final Set<AbsFlexibleColumn<T>> leftPinnedColumns;

  @override
  final Set<AbsFlexibleColumn<T>> rightPinnedColumns;

  @override
  final Set<AbsFlexibleColumn<T>> scrollableColumns;

  FlexibleTableConfigurations<T> copyWith({
    AbsFlexibleTableRowHeight<T>? rowHeight,
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  }) =>
      FlexibleTableConfigurations<T>(
        rowHeight: rowHeight ?? this.rowHeight,
        leftPinnedColumns: leftPinnedColumns ?? this.leftPinnedColumns,
        rightPinnedColumns: rightPinnedColumns ?? this.rightPinnedColumns,
        scrollableColumns: scrollableColumns ?? this.scrollableColumns,
      );
}
