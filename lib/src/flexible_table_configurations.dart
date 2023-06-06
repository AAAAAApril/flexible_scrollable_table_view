import 'package:flexible_scrollable_table_view/src/constraint/flexible_table_row_height.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column.dart';

///表配置
abstract class AbsFlexibleTableConfigurations<T> {
  const AbsFlexibleTableConfigurations();

  ///表行高
  AbsFlexibleTableRowHeight<T> get rowHeight;

  @Deprecated('Use leftPinnedColumns instead.')
  Set<AbsFlexibleColumn<T>> get pinnedColumns => leftPinnedColumns;

  ///不能左右滑动的列（会堆积在左侧）
  Set<AbsFlexibleColumn<T>> get leftPinnedColumns;

  ///不能左右滑动的列（会堆积在右侧）
  Set<AbsFlexibleColumn<T>> get rightPinnedColumns;

  ///可以左右滑动的列
  Set<AbsFlexibleColumn<T>> get scrollableColumns;
}

class FlexibleTableConfigurations<T> extends AbsFlexibleTableConfigurations<T> {
  FlexibleTableConfigurations({
    required this.rowHeight,
    @Deprecated('Use leftPinnedColumns instead.') Set<AbsFlexibleColumn<T>>? pinnedColumns,
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  })  : leftPinnedColumns = leftPinnedColumns ?? pinnedColumns ?? <AbsFlexibleColumn<T>>{},
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

  FlexibleTableConfigurations copyWith({
    AbsFlexibleTableRowHeight<T>? rowHeight,
    @Deprecated('Use leftPinnedColumns instead.') Set<AbsFlexibleColumn<T>>? pinnedColumns,
    Set<AbsFlexibleColumn<T>>? leftPinnedColumns,
    Set<AbsFlexibleColumn<T>>? rightPinnedColumns,
    Set<AbsFlexibleColumn<T>>? scrollableColumns,
  }) =>
      FlexibleTableConfigurations(
        rowHeight: rowHeight ?? this.rowHeight,
        pinnedColumns: pinnedColumns ?? this.pinnedColumns,
        leftPinnedColumns: leftPinnedColumns ?? this.leftPinnedColumns,
        rightPinnedColumns: rightPinnedColumns ?? this.rightPinnedColumns,
        scrollableColumns: scrollableColumns ?? this.scrollableColumns,
      );
}
