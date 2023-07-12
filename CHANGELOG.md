## 2.12.4

* Now you can get `AbsTableBuildArguments<T>` when get column width in `AbsFlexibleTableColumnWidth<T>` and `getColumnWidth(parentWidth)` is deprecated.

## 2.12.3

* Rename `SelectableRowMixin<T>` to `TableSelectableMixin<T>`.
* Rename `SortableColumnMixin<T>` to `TableSortableMixin<T>`.
* Move build function of column header cell from `FlexibleTableHeaderCell<T>` to `AbsFlexibleColumn<T>`.
* Move build function of column info cell from `FlexibleTableInfoCell<T>` to `AbsFlexibleColumn<T>`.
* Optimize the code.

## 2.12.2

* New feature: Support for dynamically changing the width of columns based on the maximum width of content. See the Example project.

## 2.12.1

* Custom `SynchronizedScrollMixin` is now supported.

## 2.12.0

* Optimize the code of `SortableColumnMixin<T>`, and fix bugs.

## 2.11.0

* Now you will get `TableInfoRowArgumentsMixin<T>` when function `getInfoRowHeight` called in `AbsFlexibleTableRowHeight<T>`.
* Optimize the code.

## 2.10.0

* Fix bug when sort with `SliverFlexibleTableContent<T>`.
* Rename `LazyRowLayoutBuilder` to `LazyLayoutBuilder`.
* Add `LazySliverLayoutBuilder` widget who will never rebuild when `crossAxisExtent` did not changed.
* Now `AbsTableBuildArguments<T>` has the `parentWidth` field again.
* Now `switchSortColumn(newSortColumn)` supported in `FlexibleTableController<T>`.

## 2.9.1

* Rename `LazyLayoutBuilder` to `LazyRowLayoutBuilder` and will clear cache when row height changed.

## 2.9.0

* Broken changes: `AbsTableBuildArguments<T>` no longer has the `parentWidth` field.

* Now `switchSortType(newSortType)` supported in `FlexibleTableController<T>`.
* Now `findColumnById(columnId)` supported in `AbsFlexibleTableConfigurations<T>`.
* Optimize the performance of `SliverFlexibleTableContent<T>` widget.
* New widget `LazyLayoutBuilder` is added who will never rebuild when constraints did not changed.
* Any other optimizations.

## 2.8.2

* Optimize the code.
* Fix bug of `FlexibleWidth.min`.
* Add usage.

## 2.8.1

* Fix bug about placeholder widget's height.

## 2.8.0

* Remove all deprecated fields.

## 2.7.4

* Add `SynchronizedScrollController`, a `ScrollController` that synchronizes the scroll position of
  all users.

## 2.7.3

* Add height-fixed `SliverPersistentHeaderDelegate`.

## 2.7.2

* Added columns that can be pinned to the right.

## 2.7.1

* Optimize the implementation of `FlexibleWidth` and `ScrollSynchronizationMixin`.

## 2.7.0

* There are now fewer build parameter lists.

## 2.6.0

* Set column width by `AbsFlexibleTableColumnWidth`.
* Set row height by `AbsFlexibleTableRowHeight`.
* Few column width and row height implementations can be used.

## 2.5.0

* Rename `AbsFlexibleHeaderFooter` to `AbsFlexibleTableAdditions`.
* Support set placeholder widget when table data is empty.
* A listenable value named `loadedDataOnce` in `FlexibleTableController` which means whether data
  has loaded once.

## 2.4.3

* Fix bug.

## 2.4.2

* Optimize the code.

## 2.4.1

* Fix bug.
* `AbsFlexibleTableConfigurations` is now available when building column Widgets.

## 2.4.0

* Add `AbsFlexibleTableAnimations` configuration class for config size change animation.
* Add `AnimatedConstraintBox` widget who will do animation when size changed.
* Add `AbsFlexibleHeaderFooter` configuration class for create table content header and footer.

## 2.3.0

* Add header.
* Only the table content area is supported.

## 2.2.1

* Add example screenshot.

## 2.2.0

* Add `AbsFlexibleTableDecorations` and remove `AbsFlexibleTableRowDecoration`.

## 2.1.1

* Fix bug.

## 2.1.0

* Dart SDK version from '>=2.18.5 <3.0.0' to '>=2.18.5 <4.0.0'.

## 2.0.0

* All scrollable area built by ListView. Now you can load many data or many columns but without
  performance issues.
* Minimum version of Flutter SDK supported is 3.0.0

## 1.0.0

* Init version.
