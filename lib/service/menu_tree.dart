// Mohamed Ali
// mo7amedaliebaid@gmail.com

import '../model/placeholder_models.dart';

/// An abstract node in a menu tree, with an attached element.
/// See [MenuTreeRoot] for more information.
abstract class MenuTreeNode<T> {
  /// The element attached to this node.
  final T element;

  /// The categories of this node.
  final List<MenuTreeCategory> categories = [];

  /// The entries of this node.
  final List<MenuTreeEntry> containedEntries;

  /// The depth of this node in the tree.
  int depth = 0;

  /// The parent of this node.
  MenuTreeNode? _parent;

  /// The parent of this node.
  MenuTreeNode? get parent => _parent;

  /// The parent of this node. Setting this will also update the parent's
  /// children. Additionally, the [depth] of this node will be updated.
  set parent(MenuTreeNode? parent);

  /// Traverse this node and its children in preorder.
  /// Entries will be inserted directly after their parent category, and before
  /// any of its subcategories.
  /// Mohamed Ali
  /// mo7amedaliebaid@gmail.com

  List<MenuTreeNode> traverse() {
    List<MenuTreeNode> menuList = [];
    menuList.add(this);

    // Traverse the categories in pre-order and add them to the menuList.
    for (final category in categories) {
      menuList.addAll(category.traverse());
    }

    // Traverse the entries in pre-order and add them to the menuList.
    for (final entry in containedEntries) {
      menuList.addAll(entry.traverse());
    }

    return menuList;
  }

  /// Mohamed Ali
  /// mo7amedaliebaid@gmail.com
  MenuTreeNode(this.element, this.containedEntries);
}

/// An inner node in a menu tree, representing a category.
class MenuTreeCategory extends MenuTreeNode<Category> {
  // We add any leaf children as entries for this category.
  // Note that categories do not contain their subcategories' entries,
  // which is good, because each subcategory will handle its own entries.
  MenuTreeCategory(Category category)
      : super(
            category, category.entries.map((e) => MenuTreeEntry(e)).toList()) {
    // After having added the entries, we still need to set their parent.
    for (final entry in containedEntries) {
      entry.parent = this;
    }
  }

  @override
  set parent(MenuTreeNode? parent) {
    if (parent == _parent) {
      // Nothing to be done.
      return;
    }

    if (_parent != null) {
      // Remove this node from its old parent's children.
      _parent!.categories.remove(this);
    }
    _parent = parent;
    if (parent != null) {
      // Add this node to its new parent's children.
      parent.categories.add(this);
      depth = parent.depth + 1;
    }
  }

  /// The number of entries contained in this category or any of its
  /// subcategories.
  int? _numEntries;

  /// The number of entries contained in this category or any of its
  /// subcategories.
  int get entryCount =>
      _numEntries ??= traverse().whereType<MenuTreeEntry>().length;
}

/// A leaf in a menu tree, representing an entry.
class MenuTreeEntry extends MenuTreeNode<Entry> {
  MenuTreeEntry(Entry entry) : super(entry, []);

  @override
  set parent(MenuTreeNode? parent) {
    _parent = parent;
    if (parent != null) {
      depth = parent.depth + 1;
    }
  }
}

/// A tree representing a menu, where each inner node is a category and each
/// leaf is an entry. This class basically serves as the root of the tree.
class MenuTreeRoot extends MenuTreeNode<Menu> {
  MenuTreeRoot(Menu menu, {bool includeEmptyCategories = true})
      : super(menu, []) {
    _buildTree(includeEmptyCategories);
  }

  /// Builds the tree from the root.
  /// If [includeEmptyCategories] is true, categories without any entries or
  /// subcategories will also be included.
  void _buildTree(bool includeEmptyCategories) {
    final List<Category> categories = element.categories;
    // A map from category IDs to categories.
    final Map<String, MenuTreeCategory> categoryMap = {};
    // A map containing categories whose parent category has not yet been
    // encountered. The key is the category ID *of the missing parent*,
    // and the value is a list of the categories that are missing that parent.
    final Map<String, List<MenuTreeNode>> orphanNodes = {};

    /// Sets the parent of [category] to the category with ID [baseCategoryId].
    /// If the parent category has not yet been encountered, adds [category]
    /// to the list of [orphanNodes] for that category.
    void setParent(String baseCategoryId, MenuTreeCategory category) {
      // This is not a root category.
      final MenuTreeCategory? parent = categoryMap[baseCategoryId];
      if (parent == null) {
        // We haven't encountered the parent category yet. This is an orphan.
        orphanNodes[baseCategoryId] = (orphanNodes[baseCategoryId] ?? [])
          ..add(category);
      } else {
        // We have encountered the parent category already and can set it.
        category.parent = parent;
      }
    }

    /// Takes in a new [category] and checks if any of the [orphanNodes]
    /// belong to it. If so, sets the parent of the orphan node to [category].
    void handlePossibleParent(MenuTreeCategory category) {
      final String categoryId = category.element.id;
      final List<MenuTreeNode> orphans = orphanNodes[categoryId] ?? [];
      for (final orphan in orphans) {
        orphan.parent = category;
      }
      orphanNodes.remove(categoryId);
    }

    /// Prune empty categories if necessary.
    /// Can only be called after the tree has been built.
    void pruneEmptyCategories() {
      traverse().whereType<MenuTreeCategory>().forEach((category) {
        if (category.containedEntries.isEmpty && category.categories.isEmpty) {
          // Detach this category from the tree.
          category.parent = null;
        }
      });
    }

    // A note: The `categories` list will contain all categories, not just
    // root categories (this also means we don't need any recursion here).
    // Each category has a `baseCategory.id` field, which
    // can be used to associate it with its parent category.
    // We may encounter a category before its parent category, in which case
    // we add it to the `orphanNodes` list. When we encounter the parent
    // category later on, we can then add the category to the parent category's
    // children and remove it from the `orphanNodes` list.
    for (final category in categories) {
      final MenuTreeCategory node = MenuTreeCategory(category);
      categoryMap[category.id] = node;
      handlePossibleParent(node);
      final String? baseCategoryId = category.baseCategory?.id;
      if (baseCategoryId == null) {
        // This is a root category.
        node.parent = this;
      } else {
        setParent(baseCategoryId, node);
      }
    }

    assert(orphanNodes.isEmpty, 'There are still orphan nodes: $orphanNodes');
    if (!includeEmptyCategories) {
      pruneEmptyCategories();
    }
  }

  @override
  set parent(MenuTreeNode? parent) {
    throw UnsupportedError('MenuTreeRoot cannot have a parent.');
  }
}
