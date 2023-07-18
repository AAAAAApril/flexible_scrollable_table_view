import 'package:flexible_scrollable_table_view/src/animation/flexible_table_animations.dart';
import 'package:flexible_scrollable_table_view/src/arguments/table_row_build_arguments.dart';
import 'package:flexible_scrollable_table_view/src/decoration/flexible_table_decorations.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/synchronized_scroll_mixin.dart';
import 'package:flutter/widgets.dart';

///表信息行构建功能类
abstract class TableInfoRowBuildInterface<T> {
  ///构建表信息行
  Widget buildTableInfoRow({
    required TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableDecorations<T>? decorations,
    AbsFlexibleTableAnimations<T>? animations,
    SynchronizedScrollMixin? scrollController,
    ScrollPhysics? physics,
  });
}

mixin TableInfoRowBuildMixin<T> on TableInfoRowBuildInterface<T> {
  @override
  Widget buildTableInfoRow({
    required TableInfoRowBuildArguments<T> arguments,
    AbsFlexibleTableDecorations<T>? decorations,
    AbsFlexibleTableAnimations<T>? animations,
    SynchronizedScrollMixin? scrollController,
    ScrollPhysics? physics,
  }) {
    final Widget child = _FlexibleTableInfoRow<T>(
      arguments,
      animations: animations,
      decorations: decorations,
      scrollController: scrollController,
      physics: physics,
    );
    final BoxConstraints constraints = arguments.rowConstraint;
    return animations?.buildTableInfoRowConstraintAnimationWidget(
          arguments,
          constraints: constraints,
          rowWidget: child,
        ) ??
        ConstrainedBox(constraints: constraints, child: child);
  }
}

class _FlexibleTableInfoRow<T> extends StatelessWidget {
  const _FlexibleTableInfoRow(
    this.arguments, {
    super.key,
    this.decorations,
    this.animations,
    this.scrollController,
    this.physics,
  });

  final TableInfoRowBuildArguments<T> arguments;
  final AbsFlexibleTableDecorations<T>? decorations;
  final AbsFlexibleTableAnimations<T>? animations;
  final SynchronizedScrollMixin? scrollController;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final Widget child = Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      ...arguments.configurations.leftPinnedColumns.map<Widget>(
        (e) => e.buildInfoCellInternal(arguments, animations),
      ),
      if (arguments.configurations.scrollableColumns.isNotEmpty)
        Expanded(
          child: ListView.builder(
            controller: scrollController ?? arguments.controller.horizontalScrollController,
            itemCount: arguments.scrollableColumnList.length,
            scrollDirection: Axis.horizontal,
            primary: false,
            padding: EdgeInsets.zero,
            physics: physics,
            itemBuilder: (context, index) => arguments.scrollableColumnList[index].buildInfoCellInternal(
              arguments,
              animations,
            ),
          ),
        ),
      ...arguments.configurations.rightPinnedColumns.map<Widget>(
        (e) => e.buildInfoCellInternal(arguments, animations),
      ),
    ]);
    return decorations?.buildTableInfoRowDecorationWidget(arguments, child) ?? child;
  }
}
