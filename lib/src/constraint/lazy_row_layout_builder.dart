import 'package:flutter/widgets.dart';

///可以减少重新构建的 [LayoutBuilder]
class LazyRowLayoutBuilder extends StatefulWidget {
  const LazyRowLayoutBuilder({
    super.key,
    required this.rowHeight,
    required this.builder,
  });

  final double rowHeight;
  final Widget Function(BuildContext context, double parentWidth) builder;

  @override
  State<LazyRowLayoutBuilder> createState() => _LazyRowLayoutBuilderState();
}

class _LazyRowLayoutBuilderState extends State<LazyRowLayoutBuilder> {
  Widget? cache;
  double? lastWidth;

  @override
  void didUpdateWidget(covariant LazyRowLayoutBuilder oldWidget) {
    if (oldWidget.rowHeight != widget.rowHeight) {
      cache = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        //没有缓存的情况
        if (cache == null) {
          lastWidth = constraints.maxWidth;
          cache = widget.builder.call(context, constraints.maxWidth);
          return cache!;
        }
        //有缓存，但是约束变化了
        else if (lastWidth != constraints.maxWidth) {
          lastWidth = constraints.maxWidth;
          cache = widget.builder.call(context, constraints.maxWidth);
          return cache!;
        }
        //有缓存，约束也没变
        else {
          return cache!;
        }
      },
    );
  }
}
