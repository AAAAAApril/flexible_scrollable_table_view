import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_configurations.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flexible_scrollable_table_view/src/scrollable/table_horizontal_scroll_mixin.dart';
import 'package:flutter/widgets.dart';

///构建表行所需参数
abstract class AbsTableBuildArguments<T> {
  const AbsTableBuildArguments();

  @Deprecated('Use dataSource instead.')
  FlexibleTableDataSource<T> get controller => dataSource;

  ///数据源
  FlexibleTableDataSource<T> get dataSource;

  ///横向滚动功能
  TableHorizontalScrollMixin get horizontalScrollMixin;

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

///表行约束
mixin TableRowConstraintMixin<T> on AbsTableBuildArguments<T> {
  ///当前行的高度
  double get rowHeight;

  ///当前行的大小约束
  late final BoxConstraints rowConstraint = BoxConstraints.tightFor(width: parentWidth, height: rowHeight);
}

///行数据
mixin TableInfoRowArgumentsMixin<T> on AbsTableBuildArguments<T> {
  ///当前行所在下标
  int get dataIndex;

  ///数据总长度
  int get dataLength;

  ///当前 列表项 下标
  int get itemIndex;

  ///列表项 总数
  int get itemCount;

  ///当前行数据
  T get data;
}

///构建表所需参数
class TableBuildArguments<T> extends AbsTableBuildArguments<T> {
  TableBuildArguments({
    required this.dataSource,
    required this.horizontalScrollMixin,
    required this.configurations,
    required this.parentWidth,
  });

  @override
  final FlexibleTableDataSource<T> dataSource;

  @override
  final TableHorizontalScrollMixin horizontalScrollMixin;

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
