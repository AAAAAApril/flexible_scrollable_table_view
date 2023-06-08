import 'package:flutter/widgets.dart';

///可以同步多个使用者的控制器
class SynchronizedScrollController extends ScrollController {
  SynchronizedScrollController({
    super.initialScrollOffset,
    super.keepScrollOffset,
    super.debugLabel,
  });

  final Map<ScrollPosition, VoidCallback> _positionToListener = <ScrollPosition, VoidCallback>{};

  double? _lastUpdatedOffset;

  @override
  double get initialScrollOffset => _lastUpdatedOffset ?? super.initialScrollOffset;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return ScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    assert(!_positionToListener.containsKey(position));
    _positionToListener[position] = () {
      if (!position.isScrollingNotifier.value) {
        return;
      }
      _lastUpdatedOffset = position.pixels;
      final target = initialScrollOffset;
      for (final element in List.of(positions)..remove(position)) {
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
    if (_positionToListener.isEmpty) {
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
