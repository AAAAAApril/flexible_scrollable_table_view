import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'size_listenable_widget.dart';

///可以同步最大组件宽度的组
///[ID] 组内成员的唯一标识
class IntrinsicWidthGroup<ID> extends ChangeNotifier implements ValueListenable<Map<ID, double?>> {
  IntrinsicWidthGroup({
    this.keepChildWidth = false,
    this.widthLowerBound,
    this.widthUpperBound,
  })  : assert(
          widthLowerBound == null || widthUpperBound == null || widthUpperBound >= widthLowerBound,
          '宽度的上界必须大于等于下界',
        ),
        super();

  ///宽高的上下界
  final double? widthLowerBound;
  final double? widthUpperBound;

  ///是否保留成员的宽度（若为 true，在成员被销毁时，不会其宽度缓存）
  final bool keepChildWidth;

  ///组内成员的宽度值中的最大值
  double? _maxWidth = 0;

  double? get maxWidth => _maxWidth;

  Map<ID, double?> _widthCaches = <ID, double?>{};

  @override
  Map<ID, double?> get value => _widthCaches;

  ///清空宽度缓存
  void clearWidthCaches({
    bool notifyListeners = true,
  }) {
    _widthCaches = <ID, double?>{};
    _calculateMaxWidth(_widthCaches);
    if (notifyListeners) {
      this.notifyListeners();
    }
  }

  ///获取成员的宽度缓存
  double? getWidthCache(ID childId) {
    return value[childId];
  }

  ///该成员是否有宽度缓存
  bool hasWidthCache(ID childId) {
    return value.containsKey(childId);
  }

  ///更新成员的宽度缓存
  void notifyWidth(ID childId, double? width) {
    final newValue = Map.of(value)..[childId] = width;
    _calculateMaxWidth(newValue);
    _widthCaches = newValue;
    notifyListeners();
  }

  ///移除某个成员的宽度缓存
  void removeWidth(ID childId) {
    final newValue = Map.of(value)..remove(childId);
    _calculateMaxWidth(newValue);
    _widthCaches = newValue;
    notifyListeners();
  }

  ///组内成员创建了
  @mustCallSuper
  void onChildCreated(ID childId) {
    //在需要缓存宽度时，如果该成员已经缓存过了，则不设置默认值
    if (keepChildWidth && hasWidthCache(childId)) {
      return;
    }
    notifyWidth(childId, null);
  }

  ///组内成员销毁了
  @mustCallSuper
  void onChildDestroyed(ID childId) {
    //如果需要缓存宽度，则不移除缓存
    if (keepChildWidth) {
      return;
    }
    removeWidth(childId);
  }

  ///组内成员的宽度变更了
  @mustCallSuper
  void onChildWidthChanged(ID childId, double? width) {
    notifyWidth(childId, width);
  }

  ///计算最大宽度
  void _calculateMaxWidth(Map<ID, double?> allWidth) {
    _maxWidth = allWidth.values.fold<double?>(
      null,
      (previousValue, element) {
        if (previousValue == null && element == null) {
          return null;
        }
        if (previousValue == null) {
          return element;
        } else if (element == null) {
          return previousValue;
        }
        return max<double>(previousValue, element);
      },
    );
    if (_maxWidth != null) {
      //不能小于下界
      if (widthLowerBound != null && _maxWidth! < widthLowerBound!) {
        _maxWidth = widthLowerBound;
      }
      //不能大于上界
      if (widthUpperBound != null && _maxWidth! > widthUpperBound!) {
        _maxWidth = widthUpperBound;
      }
    }
    //当最大宽度不存在时，使用最小值
    else {
      _maxWidth = widthLowerBound;
    }
  }
}

///会同步最大宽度的成员
class IntrinsicWidthChild<ID> extends StatefulWidget {
  const IntrinsicWidthChild(
    this.childId, {
    super.key,
    required this.group,
    required this.fixedHeight,
    required this.child,
  });

  ///当前成员的唯一标识
  final ID childId;

  ///所属组
  final IntrinsicWidthGroup<ID> group;

  ///包裹的内容
  final Widget child;

  ///内容的固有高度
  final double fixedHeight;

  @override
  State<IntrinsicWidthChild<ID>> createState() => _IntrinsicWidthChildState<ID>();
}

class _IntrinsicWidthChildState<ID> extends State<IntrinsicWidthChild<ID>> {
  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  void didUpdateWidget(covariant IntrinsicWidthChild<ID> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childId != widget.childId || oldWidget.group != widget.group) {
      _onDispose(oldWidget);
      _onInit();
    }
  }

  @override
  void dispose() {
    _onDispose(widget);
    super.dispose();
  }

  void _onInit() {
    widget.group.onChildCreated(widget.childId);
    widget.group.addListener(onGroupWidthChanged);
    localWidth = null;
  }

  void _onDispose(IntrinsicWidthChild<ID> widget) {
    widget.group.removeListener(onGroupWidthChanged);
    widget.group.onChildDestroyed(widget.childId);
  }

  double? localWidth;

  ///组内的宽度记录变更了
  void onGroupWidthChanged() {
    if (localWidth == widget.group.maxWidth) {
      return;
    }
    localWidth = widget.group.maxWidth;
    Future.delayed(Duration.zero, () {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  ///内部组件大小变更
  void onSizeChanged(Size? value) {
    final double? newWidth = value?.width;
    if (localWidth == newWidth) {
      return;
    }
    widget.group.onChildWidthChanged(widget.childId, newWidth);
  }

  @override
  Widget build(BuildContext context) {
    return SizeListenableWidget(
      onSizeChanged: onSizeChanged,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: localWidth,
          height: widget.fixedHeight,
        ),
        child: widget.child,
      ),
    );
  }
}
