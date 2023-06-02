import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_row_height.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';

///表配置
abstract class AbsFlexibleTableConfigurations<T> {
  const AbsFlexibleTableConfigurations();

  ///表行高
  AbsFlexibleTableRowHeight<T> get rowHeight;

  ///不能左右滑动的列（会堆积在左侧）
  Set<AbsFlexibleColumn<T>> get pinnedColumns;

  ///可以左右滑动的列
  Set<AbsFlexibleColumn<T>> get scrollableColumns;
}

class FlexibleTableConfigurations<T> extends AbsFlexibleTableConfigurations<T> {
  FlexibleTableConfigurations({
    required this.rowHeight,
    Set<AbsFlexibleColumn<T>>? pinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  })  : pinnedColumns = pinnedColumns ?? <AbsFlexibleColumn<T>>{},
        scrollableColumns = scrollableColumns ?? <AbsFlexibleColumn<T>>{};

  @override
  final AbsFlexibleTableRowHeight<T> rowHeight;

  ///不能左右滑动的列（会堆积在左侧）
  @override
  final Set<AbsFlexibleColumn<T>> pinnedColumns;

  ///可以左右滑动的列
  @override
  final Set<AbsFlexibleColumn<T>> scrollableColumns;

  FlexibleTableConfigurations copyWith({
    AbsFlexibleTableRowHeight<T>? rowHeight,
    Set<AbsFlexibleColumn<T>>? pinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  }) =>
      FlexibleTableConfigurations(
        rowHeight: rowHeight ?? this.rowHeight,
        pinnedColumns: pinnedColumns ?? this.pinnedColumns,
        scrollableColumns: scrollableColumns ?? this.scrollableColumns,
      );
}
