import 'package:flutter/material.dart';

import '../../model/placeholder_models.dart';

/// A persistent tab bar that displays its [categories] and allows the user to
/// navigate between them.
///
/// Note that the actual content of the tabs is not managed by this widget.
/// It is defined in [MenuTabBarWidget].
class PersistentMenuTabBar extends SliverPersistentHeaderDelegate {
  /// The categories to display in the tab bar.
  final List<Category> categories;

  /// The tab controller responsible for managing the tabs.
  final TabController controller;

  /// A callback that is called when a tab is tapped.
  /// The index of the tapped tab (within [categories]) is passed as an argument.
  final Function(int) onTabTap;

  PersistentMenuTabBar({required this.categories, required this.controller, required this.onTabTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    const double maxRadius = 15; // Radius of this tab bar's corners.
    return AppBar(
      title: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Center(
              child: MenuTabBarWidget(
            categories,
            controller: controller,
            onTabTap: onTabTap,
          ))),
      automaticallyImplyLeading: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: const Radius.circular(maxRadius),
              top: Radius.circular((1 - shrinkOffset / maxExtent) * maxRadius))),
    );
  }

  @override
  double get maxExtent => 58;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

/// A widget that displays a tab bar with the [categories] of a menu.
class MenuTabBarWidget extends StatefulWidget {
  /// The categories to display in the tab bar.
  final List<Category> categories;

  /// The tab controller responsible for managing the tabs.
  final TabController controller;

  /// A callback that is called when a tab is tapped.
  final void Function(int index) onTabTap;

  const MenuTabBarWidget(this.categories, {required this.controller, required this.onTabTap, super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenuTabBarState();
  }
}

class _MenuTabBarState extends State<MenuTabBarWidget> {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          // The gradient is used to fade out the edges of the tab bar.
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            // The tab bar fades in from 1–10% and out from 90–99%.
            stops: [0.01, 0.1, 0.5, 0.9, 0.99],
            colors: [Colors.transparent, Colors.white, Colors.white, Colors.white, Colors.transparent],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            tabAlignment: TabAlignment.center,
            controller: widget.controller,
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            onTap: widget.onTabTap,
            tabs: [const Icon(Icons.arrow_upward), ...widget.categories.map((e) => Tab(text: e.name))]));
  }
}
