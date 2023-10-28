## 使用方法
```dart
Column(children: [
  FlexibleTableHeader<T>(
    dataSource,
    rowBuilder: rowBuilder,
  ),
  Expanded(
    child: FlexibleTableContent<T>(
      dataSource,
      rowBuilder: rowBuilder,
    ),
  ),
]);
```
### 其中
* `T`为表格每一行的数据类型
* `dataSource`为表格数据源，其类型为`FlexibleTableDataSource<T>`。它是`ChangeNotifier`的子类，并实现了`ValueListenable<List<T>>`，类似`ValueNotifier<T>`
* `rowBuilder`为表行构建代理类。在`FlexibleTableHeader<T>`中为`FlexibleTableHeaderRowBuilderMixin<T>`类型，在`FlexibleTableContent<T>`中为`FlexibleTableInfoRowBuilderMixin<T>`类型。
### 类介绍
* 
