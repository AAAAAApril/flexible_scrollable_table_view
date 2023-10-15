import 'package:flexible_scrollable_table_view/src/arguments/table_build_arguments.dart';

import 'appointed_column_width.dart';

///固定的宽度
final class FixedWidth<T> extends AppointedColumnWidth<T> with KnownColumnWidthMixin<T> {
  const FixedWidth(this.fixedWidth)
      : assert(fixedWidth >= 0, 'The fixedWidth of column width must not be negative value.');

  final double fixedWidth;

  @override
  double getKnownWidth(TableBuildArgumentsMixin<T> arguments) => fixedWidth;
}
