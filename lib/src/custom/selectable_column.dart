import 'package:flexible_scrollable_table_view/src/flexible_column.dart';

///定制化的可选中的 Column
class SelectableColumn<T> extends FlexibleColumn<T> {
  const SelectableColumn(
    super.id, {
    required super.fixedWidth,
    required super.nameBuilder,
    required super.infoBuilder,
    super.nameAlignment,
    super.infoAlignment,
  });
}
