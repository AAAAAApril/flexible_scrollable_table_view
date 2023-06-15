import 'package:flutter/widgets.dart';

///可以减少重新构建的 [SliverLayoutBuilder]
class LazySliverLayoutBuilder extends StatefulWidget {
  const LazySliverLayoutBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, double parentWidth) builder;

  @override
  State<LazySliverLayoutBuilder> createState() => _LazySliverLayoutBuilderState();
}

class _LazySliverLayoutBuilderState extends State<LazySliverLayoutBuilder> {
  Widget? cache;
  double? lastWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cache = null;
  }

  @override
  void didUpdateWidget(covariant LazySliverLayoutBuilder oldWidget) {
    cache = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    cache = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        //没有缓存的情况
        if (cache == null) {
          lastWidth = constraints.crossAxisExtent;
          cache = widget.builder.call(context, constraints.crossAxisExtent);
          return cache!;
        }
        //有缓存，但是约束变化了
        else if (lastWidth != constraints.crossAxisExtent) {
          lastWidth = constraints.crossAxisExtent;
          cache = widget.builder.call(context, constraints.crossAxisExtent);
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
