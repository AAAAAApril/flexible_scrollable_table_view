import 'package:flutter/widgets.dart';

///高度固定的固定头部
class FixedSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const FixedSliverPersistentHeaderDelegate(
    this.fixedHeight, {
    required this.child,
  });

  final Widget child;
  final double fixedHeight;

  @override
  double get minExtent => fixedHeight;

  @override
  double get maxExtent => fixedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant FixedSliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.fixedHeight != fixedHeight || oldDelegate.child != child;
  }
}
