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
        if (cache == null || lastWidth != constraints.crossAxisExtent) {
          lastWidth = constraints.crossAxisExtent;
          cache = builder.call(context, constraints.crossAxisExtent);
        }
        return cache!;
      },
    );
  }
}
