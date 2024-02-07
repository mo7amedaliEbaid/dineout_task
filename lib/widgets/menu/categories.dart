// Mohamed Ali
// mo7amedaliebaid@gmail.com

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

// Mohamed Ali
// mo7amedaliebaid@gmail.com

class CategoryOverviewWidget extends StatelessWidget {
  /// The root of the menu tree.
  final MenuTreeRoot menuTree;

  /// The name of the restaurant.
  final String restaurantName;

  const CategoryOverviewWidget(
      {required this.menuTree, required this.restaurantName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$restaurantName: Categories'),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                ...menuTree.categories.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final MenuTreeCategory category = entry.value;

                  return CategoryWidget(
                    category: category,
                    onTap: () {
                      // Navigate back and pass the index of the selected category.
                      Navigator.pop(context, index);
                    },
                  );
                }),
              ],
            ),
          ),
        ));
  }
}

// Mohamed Ali
// mo7amedaliebaid@gmail.com
/// A widget that represents a category in the wrap.
class CategoryWidget extends StatelessWidget {
  final MenuTreeCategory category;
  final VoidCallback onTap;

  const CategoryWidget(
      {required this.category, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return InkWell(
        onTap: onTap,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          elevation: 3,
          child: Container(
            width: width > 800 ? 350 : 150,
            height: width > 800 ? 350 : 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.pink)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.element.name,
                  style: TextStyle(
                      fontSize: width > 800 ? 30 : 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: width > 800 ? 30 : 8.0),
                Text('${category.entryCount} entries'),
              ],
            ),
          ),
        ));
  }
}
// Mohamed Ali
// mo7amedaliebaid@gmail.com
