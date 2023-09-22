import 'package:flexible_scrollable_table_view/src/flexible_column.dart';

///可排序 Column
mixin SortableColumnMixin<T> on AbsFlexibleColumn<T> {
  int compare(T a, T b);
}
