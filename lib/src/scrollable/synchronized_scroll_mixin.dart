import 'package:flutter/widgets.dart';

///可以同步每个滚动组件的扩展功能
mixin SynchronizedScrollMixin on ScrollController {
  final Map<ScrollPosition, VoidCallback> _positionToListener = <ScrollPosition, VoidCallback>{};

  bool get keepOffsetWhenNoClients => false;

  double? _lastUpdatedOffset;

  @override
  double get initialScrollOffset => _lastUpdatedOffset ?? super.initialScrollOffset;

  @override
  void jumpTo(double value) {
    _lastUpdatedOffset = value;
    super.jumpTo(value);
  }

  @override
  Future<void> animateTo(double offset, {required Duration duration, required Curve curve}) {
    _lastUpdatedOffset = offset;
    return super.animateTo(offset, duration: duration, curve: curve);
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    assert(!_positionToListener.containsKey(position));
    _positionToListener[position] = () {
      if (!position.isScrollingNotifier.value || _lastUpdatedOffset == position.pixels) {
        return;
      }
      _lastUpdatedOffset = position.pixels;
      final target = initialScrollOffset;
      for (final element in Set.of(positions)..remove(position)) {
        if (element.pixels != target && target <= element.maxScrollExtent) {
          element.jumpTo(target);
        }
      }
    };
    position.addListener(_positionToListener[position]!);
  }

  @override
  void detach(ScrollPosition position) {
    super.detach(position);
    assert(_positionToListener.containsKey(position));
    position.removeListener(_positionToListener[position]!);
    _positionToListener.remove(position);
    if (_positionToListener.isEmpty && !keepOffsetWhenNoClients) {
      _lastUpdatedOffset = null;
    }
  }

  @override
  void dispose() {
    for (final ScrollPosition position in positions) {
      assert(_positionToListener.containsKey(position));
      position.removeListener(_positionToListener[position]!);
    }
    super.dispose();
  }
}

class SynchronizedScrollController extends ScrollController with SynchronizedScrollMixin {
  SynchronizedScrollController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
    this.keepOffsetWhenNoClients = false,
  });

  @override
  final bool keepOffsetWhenNoClients;
}
