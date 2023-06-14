## Usage

* 1、Init `FlexibleTableController<T>` and release in `dispose()` lifecycle callback functions. (Required)
```dart
late FlexibleTableController<T> controller;

@override
void initState() {
  super.initState();
  controller = FlexibleTableController<T>();
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

* 2、Init `AbsFlexibleTableConfigurations<T>` and add some instances of `AbsFlexibleColumn<T>`. (Required)   
`rowHeight` is required and subclass of `AbsFlexibleTableRowHeight<T>`.   
`leftPinnedColumns` is optional and place columns pinned at left.   
`rightPinnedColumns` is optional and place columns pinned at right.   
`scrollableColumns` is optional and place columns in a horizontal-scrolling ListView.
```dart
AbsFlexibleTableConfigurations<T> configurations = FlexibleTableConfigurations<T>(
  rowHeight: const FixedHeight(
    headerRowHeight: 40,
    fixedInfoRowHeight: 50,
  ),
  leftPinnedColumns: {},
  rightPinnedColumns: {},
  scrollableColumns: {},
);
```

* 3、Init `FlexibleTableHeader<T>` widget. (Optional)   
Instance of `FlexibleTableController<T>` is required.    
Instance of `AbsFlexibleTableConfigurations<T>` is required. 
```dart
FlexibleTableHeader<T>(
  controller,
  configurations: configurations,
);
```

* 4、Init `FlexibleTableContent<T>` widget.  (Required)
```dart
FlexibleTableContent<T>(
  controller,
  configurations: configurations,
);
```

* Example project for more usage.

## Example

![selecting](https://github.com/AAAAAApril/flexible_scrollable_table_view/blob/pub/example/img_1.jpg?raw=true)
![not selectable](https://github.com/AAAAAApril/flexible_scrollable_table_view/blob/pub/example/img.jpg?raw=true)
