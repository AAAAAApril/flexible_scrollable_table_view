import 'package:flexible_scrollable_table_view/src/flexible_column.dart';
import 'package:flutter/widgets.dart';

///用于缓存列项的 Widget 实例
///有时候，某一列在不同行时会出现相同的值，而相同的值又会对应一样的 Widget，为了避免重复创建，可以混入当前类，手动缓存 Widget
mixin TableCellWidgetCacheMixin<T> on AbsFlexibleColumn<T> {
  final Map<Object, Widget> _cellCache = <Object, Widget>{};

  ///设置缓存
  void setCacheWidget(Object key, Widget value) => _cellCache[key] = value;

  ///获取缓存
  Widget? getCacheWidget(Object key) => _cellCache[key];

  ///根据条件获取缓存
  MapEntry<Object, Widget>? getCacheWhere(bool Function(MapEntry<Object, Widget> element) test) {
    try {
      return _cellCache.entries.firstWhere(test);
    } catch (_) {
      return null;
    }
  }

  ///是否包含 key
  bool containsCacheKey(Object key) => _cellCache.containsKey(key);

  ///是否包含 widget
  bool containsCacheValue(Widget value) => _cellCache.containsValue(value);

  ///根据条件判断是否包含
  bool containsCacheWhere(bool Function(MapEntry<Object, Widget> element) test) {
    try {
      _cellCache.entries.firstWhere(test);
      return true;
    } catch (_) {
      return false;
    }
  }

  ///移除缓存
  void removeCacheWidget(Object key) => _cellCache.remove(key);

  ///根据条件移除缓存
  void removeCacheWhere(bool Function(Object key, Widget value) test) => _cellCache.removeWhere(test);
}
