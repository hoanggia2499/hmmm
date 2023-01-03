import 'package:flutter/material.dart';

class FlexibleCarInfoHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  Widget expandedChild;
  FlexibleExtent extent;

  FlexibleCarInfoHeader(this.context, this.expandedChild, this.extent);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var progress = shrinkOffset / maxExtent;

    return Material(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: 1 - progress,
            child: expandedChild,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => extent.maxExtent;

  @override
  double get minExtent => extent.minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class FlexibleExtent {
  double minExtent;
  double maxExtent;

  FlexibleExtent({
    required this.minExtent,
    required this.maxExtent,
  });
}
