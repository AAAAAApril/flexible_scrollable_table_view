import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PrescientWidthGroup extends ChangeNotifier implements ValueListenable<double> {
  final Map<int, double> _widthCache = <int, double>{};

  double _maxWidth = 0;

  @override
  double get value => _maxWidth;

  void _onChildCreated(int index, double width) {
    _widthCache[index] = width;
    final newWidth = _calculatesMaxWidth();
    if (newWidth == _maxWidth) {
      return;
    }
    _maxWidth = newWidth;
    notifyListeners();
  }

  void _onChildNotify(int index, double width) {
    if (_widthCache[index] == width) {
      return;
    }
    _widthCache[index] = width;
    final newWidth = _calculatesMaxWidth();
    if (newWidth == _maxWidth) {
      return;
    }
    _maxWidth = newWidth;
    notifyListeners();
  }

  void _onChildDestroy(int index) {
    _widthCache.remove(index);
    final newWidth = _calculatesMaxWidth();
    if (newWidth == _maxWidth) {
      return;
    }
    _maxWidth = newWidth;
    notifyListeners();
  }

  bool _marked = false;

  @override
  void notifyListeners() {
    if (_marked) {
      return;
    }
    _marked = true;
    Future.delayed(Duration.zero, () {
      _marked = false;
      if (!hasListeners) {
        return;
      }
      super.notifyListeners();
    });
  }

  double _calculatesMaxWidth() {
    return _widthCache.values.fold<double>(0, max<double>);
  }

  @override
  void dispose() {
    super.dispose();
    _widthCache.clear();
  }
}

class PrescientWidthChild extends StatefulWidget {
  const PrescientWidthChild(
    this.index, {
    super.key,
    required this.group,
    required this.width,
    required this.child,
  });

  final int index;
  final PrescientWidthGroup group;
  final double width;
  final Widget child;

  @override
  State<PrescientWidthChild> createState() => _PrescientWidthChildState();
}

class _PrescientWidthChildState extends State<PrescientWidthChild> {
  @override
  void initState() {
    super.initState();
    widget.group._onChildCreated(widget.index, widget.width);
  }

  @override
  void didUpdateWidget(covariant PrescientWidthChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      oldWidget.group._onChildDestroy(oldWidget.index);
      widget.group._onChildCreated(widget.index, widget.width);
    } else {
      widget.group._onChildNotify(widget.index, widget.width);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.group._onChildDestroy(widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
