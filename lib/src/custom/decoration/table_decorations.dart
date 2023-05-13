import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_column_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/functions.dart';
import 'package:flutter/material.dart';

///表头区域装饰
class TableHeaderDecoration<T> extends StatelessWidget {
  const TableHeaderDecoration(
    this.controller, {
    super.key,
    required this.columnController,
    required this.columns,
    required this.decorationBuilder,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumnController<T> columnController;

  ///列配置
  final Set<FlexibleColumn<T>> columns;

  ///表头装饰
  final TableHeaderDecorationBuilder<T> decorationBuilder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: columns
          .map<Widget>(
            (e) => decorationBuilder.call(
              context,
              e,
              Size(e.fixedWidth, columnController.headerRowHeight),
            ),
          )
          .toList(growable: false),
    );
  }
}

///表内容区域装饰
class TableContentDecoration<T> extends StatelessWidget {
  const TableContentDecoration(
    this.controller, {
    super.key,
    required this.columnController,
    required this.columns,
    required this.decorationBuilder,
  });

  ///控制器
  final FlexibleTableController<T> controller;

  ///列配置
  final FlexibleColumnController<T> columnController;

  ///列配置
  final Set<FlexibleColumn<T>> columns;

  ///表信息装饰
  final TableInfoDecorationBuilder<T> decorationBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: controller,
      builder: (context, value, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: value
            .map<Widget>(
              (data) => Row(
                mainAxisSize: MainAxisSize.min,
                children: columns
                    .map<Widget>(
                      (column) => decorationBuilder.call(
                        context,
                        column,
                        Size(
                          column.fixedWidth,
                          columnController.infoRowHeightBuilder?.call(context, data) ?? columnController.infoRowHeight!,
                        ),
                        data,
                      ),
                    )
                    .toList(growable: false),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
