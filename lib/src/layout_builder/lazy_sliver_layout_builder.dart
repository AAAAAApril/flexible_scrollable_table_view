import 'package:flutter/widgets.dart';

///可以减少重新构建的 [SliverLayoutBuilder]
class LazySliverLayoutBuilder extends StatelessWidget {
  const LazySliverLayoutBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, double parentWidth) builder;

  @override
  Widget build(BuildContext context) {
    Widget? cache;
    double? lastWidth;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        //没有缓存的情况
        if (cache == null) {
          lastWidth = constraints.crossAxisExtent;
          cache = builder.call(context, constraints.crossAxisExtent);
          return cache!;
        }
        //有缓存，但是约束变化了
        else if (lastWidth != constraints.crossAxisExtent) {
          lastWidth = constraints.crossAxisExtent;
          cache = builder.call(context, constraints.crossAxisExtent);
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
