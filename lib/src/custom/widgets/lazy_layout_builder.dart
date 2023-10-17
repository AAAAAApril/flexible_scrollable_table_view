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
    double? lastWidth;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (cache == null || lastWidth != constraints.maxWidth) {
          lastWidth = constraints.maxWidth;
          cache = builder.call(context, constraints);
        }
        return cache!;
      },
    );
  }
}
