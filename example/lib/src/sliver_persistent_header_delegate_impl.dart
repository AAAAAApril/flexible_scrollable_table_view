import 'package:flutter/widgets.dart';

class SliverPersistentHeaderDelegateImpl extends SliverPersistentHeaderDelegate {
  const SliverPersistentHeaderDelegateImpl({
    required this.fixedHeight,
    required this.child,
  });

  final double fixedHeight;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegateImpl oldDelegate) =>
      fixedHeight != oldDelegate.fixedHeight || child != oldDelegate.child;
}
