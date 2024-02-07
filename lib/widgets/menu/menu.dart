import 'package:dine_out_client/service/menu_tree.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

import 'entry.dart';

/// A widget that displays the content of a menu.
///
/// The content is divided into categories, which are displayed in a tab bar.
/// The structure of the menu is defined by [menuTree], in which the categories
/// are inner nodes and the entries are leaves.
class MenuWidget extends StatelessWidget with WidgetsBindingObserver {
  /// The root of the menu tree.
  final MenuTreeRoot menuTree;

  /// A function that is called when an item widget on the menu is constructed.
  /// The function is passed the item widget and its index in the list of items.
  /// The returned widget is wrapped around the item widget.
  final Widget Function(Widget child, int index) wrapItem;

  /// A callback that is called when a category is scrolled into view.
  final void Function(int index) onCategoryScrolled;

  const MenuWidget(this.menuTree, {required this.onCategoryScrolled, required this.wrapItem, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int i) =>
          // A note: We had multiple choices for which scrolling mechanism to
          // use, but we are severely constrained by the items being placed
          // (directly or indirectly) within a sliver.
          // In this framework, ScrollablePositionedList does not work.
          // For this reason, we chose scroll_to_index, which does work.
          InViewNotifierWidget(
              id: '$i',
              builder: (BuildContext context, bool isInView, Widget? child) {
                if (isInView) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => onCategoryScrolled(i));
                }
                return wrapItem(
                    Column(children: [
                      const Divider(),
                      MenuCategoryWidget(menuTree.categories[i], menuId: menuTree.element.id),
                    ]),
                    i + 1);
              }),
      childCount: menuTree.categories.length,
    ));
  }
}

/// A widget that displays the content of a menu category.
class MenuCategoryWidget extends StatelessWidget {
  /// The list of nodes in the menu tree that are descendants of this category (including itself).
  /// The nodes are ordered in a depth-first pre-order traversal of the tree.
  final List<MenuTreeNode> traversedTree;

  /// The ID of the menu to which this category belongs.
  final String menuId;

  MenuCategoryWidget(MenuTreeCategory category, {required this.menuId, super.key})
      : traversedTree = category.traverse();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: traversedTree.length,
        itemBuilder: (BuildContext context, int index) {
          switch (traversedTree[index]) {
            case MenuTreeCategory category:
              return MenuCategoryHeaderWidget(category);
            case MenuTreeEntry entry:
              return MenuEntryWidget(entry.element,
                  menuId: menuId, backgroundColor: index % 2 == 0 ? null : Colors.grey.shade100);
            default:
              throw Exception('Unknown node type');
          }
        });
  }
}

/// A widget that displays the header of a menu category.
class MenuCategoryHeaderWidget extends StatelessWidget {
  /// The category to display.
  final MenuTreeCategory category;

  const MenuCategoryHeaderWidget(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final TextStyle? headlineTheme;
    // Format the headline according to the depth of the category in the menu tree.
    switch (category.depth) {
      case 1:
        headlineTheme = textTheme.headlineMedium;
        break;
      case 2:
        headlineTheme = textTheme.headlineSmall;
        break;
      case 3:
        headlineTheme = textTheme.titleLarge;
        break;
      default:
        headlineTheme = textTheme.titleMedium;
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(category.element.name, textAlign: TextAlign.center, style: headlineTheme));
  }
}
