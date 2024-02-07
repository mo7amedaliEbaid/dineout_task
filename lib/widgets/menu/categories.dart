import 'package:flutter/material.dart';

import '../../service/menu_tree.dart';

/// A widget that displays an overview of the categories in a menu.
/*class CategoryOverviewWidget extends StatelessWidget {
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
}*/
class CategoryOverviewWidget extends StatelessWidget {
  /// The root of the menu tree.
  final MenuTreeRoot menuTree;

  /// The name of the restaurant.
  final String restaurantName;

  const CategoryOverviewWidget({required this.menuTree, required this.restaurantName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$restaurantName: Categories'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // You can adjust the number of columns as needed
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: menuTree.categories.length,
        itemBuilder: (context, index) {
          final category = menuTree.categories[index];
          return CategoryWidget(
            category: category,
            onTap: () {
              // Navigate back and pass the index of the selected category.
              Navigator.pop(context, index);
            },
          );
        },
      ),
    );
  }
}

/// A widget that represents a category in the grid.
class CategoryWidget extends StatelessWidget {
  final MenuTreeCategory category;
  final VoidCallback onTap;

  const CategoryWidget({required this.category, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.element.name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text('${category.entryCount ?? 0} entries'),
            ],
          ),
        ),
      ),
    );
  }
}