import 'package:flutter/widgets.dart';

///可以减少重新构建的 [LayoutBuilder]
class LazyLayoutBuilder extends StatefulWidget {
  const LazyLayoutBuilder({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  @override
  State<LazyLayoutBuilder> createState() => _LazyLayoutBuilderState();
}

class _LazyLayoutBuilderState extends State<LazyLayoutBuilder> {
  Widget? cache;
  BoxConstraints? lastConstraints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        //没有缓存的情况
        if (cache == null) {
          lastConstraints = constraints;
          cache = widget.builder.call(context, constraints);
          return cache!;
        }
        //有缓存，但是约束变化了
        else if (lastConstraints != constraints) {
          lastConstraints = constraints;
          cache = widget.builder.call(context, constraints);
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
