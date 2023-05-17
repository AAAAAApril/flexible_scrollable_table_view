import 'package:flexible_scrollable_table_view/flexible_scrollable_table_view.dart';
import 'package:flutter/widgets.dart';

///普通列
class NormalColumn<T> extends AbsFlexibleColumn<T> {
  const NormalColumn(
    super.id, {
    required super.fixedWidth,
    required this.headerText,
    required this.infoText,
    this.onHeaderPressed,
    this.onInfoPressed,
    super.comparator,
  });

  final String headerText;
  final String Function(T data) infoText;
  final VoidCallback? onHeaderPressed;
  final ValueChanged<T>? onInfoPressed;

  @override
  Widget buildHeader(FlexibleTableController<T> controller, BuildContext context, Size fixedSize) {
    Widget child = SizedBox.expand(
      child: Center(
        child: Text(headerText),
      ),
    );
    if (onHeaderPressed != null || comparableColumn) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onHeaderPressed?.call();
          controller.sortByColumn(this);
        },
        child: child,
      );
    }
    return child;
  }

  @override
  Widget buildInfo(FlexibleTableController<T> controller, BuildContext context, Size fixedSize, int dataIndex, T data) {
    Widget child = SizedBox.expand(
      child: Center(
        child: Text(infoText.call(data)),
      ),
    );
    if (onInfoPressed != null) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onInfoPressed?.call(data),
        child: child,
      );
    }
    return child;
  }
}
