import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

///可以监听到自组件大小变更的组件
class SizeListenableWidget extends SingleChildRenderObjectWidget {
  const SizeListenableWidget({
    super.key,
    super.child,
    required this.onSizeChanged,
  });

  final ValueChanged<Size?> onSizeChanged;

  @override
  SizeListenableRenderObject createRenderObject(BuildContext context) {
    return SizeListenableRenderObject()..onSizeChanged = onSizeChanged;
  }

  @override
  void updateRenderObject(BuildContext context, covariant SizeListenableRenderObject renderObject) {
    renderObject.onSizeChanged = onSizeChanged;
  }

  @override
  void didUnmountRenderObject(covariant SizeListenableRenderObject renderObject) {
    renderObject.onSizeChanged = null;
    renderObject.oldSize = null;
  }
}

class SizeListenableRenderObject extends RenderProxyBox {
  SizeListenableRenderObject();

  ValueChanged<Size?>? onSizeChanged;

  Size? oldSize;

  @override
  void performLayout() {
    super.performLayout();
    Size? newSize = child?.size;
    if (oldSize == newSize) {
      return;
    }
    oldSize = newSize;
    if (onSizeChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        onSizeChanged?.call(oldSize);
      });
    }
  }
}
