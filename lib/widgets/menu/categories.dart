import 'package:flutter/material.dart';

import '../../service/menu_tree.dart';

/// A widget that displays an overview of the categories in a menu.
class CategoryOverviewWidget extends StatelessWidget {
  /// The root of the menu tree.
  final MenuTreeRoot menuTree;

  /// The name of the restaurant.
  final String restaurantName;

  const CategoryOverviewWidget({required this.menuTree, required this.restaurantName, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement the category overview screen as described in README.md.
    return Scaffold(appBar: AppBar(), body: const Center(child: Text("TODO")));
  }
}
