enum FlexibleColumnSortType {
  ///默认
  normal,

  ///升序
  ascending,

  ///降序
  descending;

  static FlexibleColumnSortType nextSortType(FlexibleColumnSortType current) {
    switch (current) {
      case FlexibleColumnSortType.normal:
        return FlexibleColumnSortType.descending;
      case FlexibleColumnSortType.ascending:
        return FlexibleColumnSortType.normal;
      case FlexibleColumnSortType.descending:
        return FlexibleColumnSortType.ascending;
    }
  }
}
