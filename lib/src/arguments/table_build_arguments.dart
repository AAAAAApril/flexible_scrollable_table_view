import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_controller.dart';

///构建表行所需参数
abstract class AbsTableBuildArguments<T> {
  const AbsTableBuildArguments();

  ///控制器
  FlexibleTableController<T> get controller;

  ///配置
  AbsFlexibleTableConfigurations<T> get configurations;

  ///父容器宽度
  double get parentWidth;

  ///不可滚动列列表（左侧）
  List<AbsFlexibleColumn<T>> get leftPinnedColumnList;

  ///不可滚动列列表（右侧）
  List<AbsFlexibleColumn<T>> get rightPinnedColumnList;

  ///可滚动列列表
  List<AbsFlexibleColumn<T>> get scrollableColumnList;
}

///构建表所需参数
class TableBuildArguments<T> extends AbsTableBuildArguments<T> {
  TableBuildArguments(
    this.controller,
    this.configurations,
    this.parentWidth,
  );

  @override
  final FlexibleTableController<T> controller;

  @override
  final AbsFlexibleTableConfigurations<T> configurations;

  @override
  final double parentWidth;

  @override
  late final List<AbsFlexibleColumn<T>> leftPinnedColumnList = configurations.leftPinnedColumns.toList(growable: false);

  @override
  late final List<AbsFlexibleColumn<T>> rightPinnedColumnList =
      configurations.rightPinnedColumns.toList(growable: false);

  @override
  late final List<AbsFlexibleColumn<T>> scrollableColumnList = configurations.scrollableColumns.toList(growable: false);
}
