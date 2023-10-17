import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///不占用空间，但可以获取到组件的真实大小
class ZeroBox extends SingleChildRenderObjectWidget {
  const ZeroBox({
    super.key,
    required this.onRealSizeCallback,
    this.constraints = const BoxConstraints(),
    required Widget super.child,
  });

  final ValueChanged<Size> onRealSizeCallback;
  final Constraints constraints;

  @override
  RenderZeroBox createRenderObject(BuildContext context) {
    return RenderZeroBox(
      layoutConstraints: constraints,
      onChildSizeCallback: onRealSizeCallback,
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderZeroBox renderObject) {
    renderObject
      ..layoutConstraints = constraints
      ..onChildSizeCallback = onRealSizeCallback;
  }

  @override
  void didUnmountRenderObject(covariant RenderZeroBox renderObject) {}
}

class RenderZeroBox extends RenderProxyBox {
  RenderZeroBox({
    required Constraints layoutConstraints,
    required this.onChildSizeCallback,
  })  : _layoutConstraints = layoutConstraints,
        super();

  ValueChanged<Size> onChildSizeCallback;

  Constraints _layoutConstraints;

  set layoutConstraints(Constraints value) {
    if (value != _layoutConstraints) {
      _layoutConstraints = value;
      markNeedsLayout();
    }
  }

  Size? _oldSize;

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(_layoutConstraints, parentUsesSize: true);
      final Size newSize = child!.size;
      if (_oldSize != newSize) {
        _oldSize = newSize;
        onChildSizeCallback.call(newSize);
      }
    }
    size = Size.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    //do nothing.
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return false;
  }

  @override
  bool paintsChild(covariant RenderObject child) {
    return false;
  }
}
