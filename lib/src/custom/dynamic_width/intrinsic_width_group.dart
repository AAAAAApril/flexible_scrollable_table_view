import 'dart:async';
import 'dart:math';

import 'package:flexible_scrollable_table_view/src/custom/flexible_table_controller.dart';
import 'package:flexible_scrollable_table_view/src/flexible_table_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'size_listenable_widget.dart';

///可以同步最大组件宽度的组
class IntrinsicWidthGroup extends ChangeNotifier implements ValueListenable<double?> {
  IntrinsicWidthGroup({
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

  ///组内成员的宽度值中的最大值
  double? _maxWidth = 0;

  final Map<int, double?> _caches = <int, double?>{};

  @override
  double? get value => _maxWidth;

  ///移除所有缓存
  void removeAllCache() {
    _caches.clear();
    _maxWidth = _calculateMaxWidth(_caches);
  }

  ///移除之后的
  void removeCacheAfter(int childId) {
    _caches.removeWhere((key, value) => key > childId);
    _maxWidth = _calculateMaxWidth(_caches);
  }

  ///更新成员的宽度缓存
  void notifyWidth(int childId, double? width) {
    _caches[childId] = width;
    _maxWidth = _calculateMaxWidth(_caches);
  }

  ///移除某个成员的宽度缓存
  void removeWidth(int childId) {
    _caches.remove(childId);
    _maxWidth = _calculateMaxWidth(_caches);
  }

  ///组内成员创建了
  @mustCallSuper
  void onChildCreated(int childId) {
    //do nothing.
  }

  ///组内成员销毁了
  @mustCallSuper
  void onChildDestroyed(int childId) {
    removeWidth(childId);
    notifyListeners();
  }

  ///组内成员的宽度变更了
  @mustCallSuper
  void onChildWidthChanged(int childId, double? width) {
    notifyWidth(childId, width);
    notifyListeners();
  }

  ///计算最大宽度
  double? _calculateMaxWidth(Map<int, double?> allWidth) {
    double? result = allWidth.values.fold<double?>(
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
    if (result != null) {
      //不能小于下界
      if (widthLowerBound != null && result < widthLowerBound!) {
        result = widthLowerBound;
      }
    }
    if (result != null) {
      //不能大于上界
      if (widthUpperBound != null && result > widthUpperBound!) {
        result = widthUpperBound;
      }
    }
    //当最大宽度不存在时，使用最小值
    result ??= widthLowerBound;
    return result;
  }
}

///会同步最大宽度的成员
class IntrinsicWidthChild extends StatefulWidget {
  const IntrinsicWidthChild(
    this.childId, {
    super.key,
    required this.controller,
    required this.group,
    required this.fixedHeight,
    required this.child,
  });

  ///当前成员的唯一标识
  final int childId;

  final FlexibleTableController<dynamic> controller;

  ///所属组
  final IntrinsicWidthGroup group;

  ///包裹的内容
  final Widget child;

  ///内容的固有高度
  final double fixedHeight;

  @override
  State<IntrinsicWidthChild> createState() => _IntrinsicWidthChildState();
}

class _IntrinsicWidthChildState extends State<IntrinsicWidthChild> {
  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  void didUpdateWidget(covariant IntrinsicWidthChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    timer?.cancel();
    realWidth = null;
    localWidth = null;
    if (oldWidget.childId != widget.childId ||
        oldWidget.child != widget.child ||
        oldWidget.group != widget.group ||
        oldWidget.controller != widget.controller) {
      _onDispose(oldWidget);
      _onInit();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _onDispose(widget);
    super.dispose();
  }

  void _onInit() {
    widget.group.onChildCreated(widget.childId);
    widget.group.addListener(onGroupWidthChanged);
    widget.controller.addValueSettingCallback(onTableValueSetting);
  }

  void _onDispose(IntrinsicWidthChild widget) {
    widget.controller.removeValueSettingCallback(onTableValueSetting);
    widget.group.removeListener(onGroupWidthChanged);
    widget.group.onChildDestroyed(widget.childId);
  }

  double? realWidth;
  double? localWidth;
  Timer? timer;

  ///表数据正准备更新
  void onTableValueSetting(dynamic oldValue, dynamic newValue) {
    timer?.cancel();
  }

  ///组内的宽度记录变更了
  void onGroupWidthChanged() {
    if (localWidth == widget.group.value) {
      return;
    }
    timer = Timer.periodic(Duration.zero, (timer) {
      timer.cancel();
      final double? maxWidth = widget.group.value;
      try {
        if (!mounted || localWidth == maxWidth || maxWidth == null || realWidth == null || realWidth! > maxWidth) {
          return;
        }
      } catch (_) {
        //ignore
      }
      localWidth = maxWidth;
      setState(() {});
    });
  }

  ///内部组件大小变更
  void onSizeChanged(Size? value) {
    final double? newWidth = value?.width;
    if (localWidth == newWidth) {
      return;
    }
    if (realWidth == null || widget.group.value != realWidth) {
      realWidth = newWidth;
    }
    widget.group.onChildWidthChanged(widget.childId, newWidth);
  }

  @override
  Widget build(BuildContext context) {
    if (realWidth == null || localWidth == null) {
      if (widget.group.widthLowerBound != null || widget.group.widthUpperBound != null) {
        if (widget.group.widthLowerBound == widget.group.widthUpperBound) {
          realWidth = widget.group.widthUpperBound;
          localWidth = widget.group.widthUpperBound;
        }
      }
    }
    return SizeListenableWidget(
      onSizeChanged: onSizeChanged,
      child: ConstrainedBox(
        constraints: localWidth != null
            ? BoxConstraints.tightFor(
                width: localWidth,
                height: widget.fixedHeight,
              )
            : BoxConstraints(
                minWidth: widget.group.widthLowerBound ?? 0.0,
                maxWidth: widget.group.widthUpperBound ?? double.infinity,
                minHeight: widget.fixedHeight,
                maxHeight: widget.fixedHeight,
              ),
        child: widget.child,
      ),
    );
  }
}
