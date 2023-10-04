## Usage

* 1、Init `FlexibleTableDataSource<T>` and release in `dispose()` lifecycle callback functions. (Required)

```dart
late FlexibleTableDataSource<T> dataSource;

@override
void initState() {
  super.initState();
  dataSource = FlexibleTableDataSource<T>();
}

@override
void dispose() {
  super.dispose();
  dataSource.dispose();
}
```

* 2、Init `FlexibleTableRowBuilderMixin<T>`. (Required)  `DefaultRowBuilder<T>` is a default implementation.

```dart

FlexibleTableRowBuilderMixin<T> rowBuilder = DefaultRowBuilder<T>(
  this,
  leftPinnedColumns: {
    const StudentIdColumn()
        //设置列宽为固定宽度
        .appointWidth(const FixedWidth(100)),
  },
  scrollableColumns: {
    const StudentNameColumn()
        //设置列宽为父容器宽度的 0.5 倍
        .appointWidth(ProportionalWidth(0.5)),
    const StudentAgeColumn()
        //给列头添加点击排序的功能
        .withSortByPressColumnHeader((column, a, b) => a.age.compareTo(b.age))
        .appointWidth(const FixedWidth(60)),
    const StudentGenderColumn()
        //给列信息项添加点击事件
        .whenInfoClicked((column, arguments, context) {
      debugPrint('点击了[${column.id}]列的第[${arguments.dataIndex}]项的数据[${arguments.data.gender}]');
    }).appointWidth(const FixedWidth(60)),
  },
)
    //给行设置固定的高度
    .appointHeight(const FixedRowHeight(headerHeight: 48, infoHeight: 48))
    .withDivider();
```

* 3、Init `FlexibleTableHeader<T>` widget.   
  Instance of `FlexibleTableDataSource<T>` is required.    
  Instance of `FlexibleTableRowBuilderMixin<T>` is required.

```dart
FlexibleTableHeader<T>(dataSource, rowBuilder: rowBuilder);
```

* 4、Init `FlexibleTableContent<T>` widget.   
  Instance of `FlexibleTableDataSource<T>` is required.    
  Instance of `FlexibleTableRowBuilderMixin<T>` is required.

```dart
FlexibleTableContent<T>(dataSource, rowBuilder: rowBuilder);
```

* 5、Set data for dataSource.
```dart
dataSource.value = <T>[];
```

* Example project for more usage.
