import 'package:flutter/widgets.dart';

///可以减少重新构建的 [LayoutBuilder]
class LazyLayoutBuilder extends StatelessWidget {
  const LazyLayoutBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  @override
  Widget build(BuildContext context) {
    Widget? cache;
    BoxConstraints? lastConstraints;
    return LayoutBuilder(
      builder: (context, constraints) {
        //没有缓存的情况
        if (cache == null) {
          lastConstraints = constraints;
          cache = builder.call(context, constraints);
          return cache!;
        }
        //有缓存，但是约束变化了
        else if (lastConstraints != constraints) {
          lastConstraints = constraints;
          cache = builder.call(context, constraints);
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
