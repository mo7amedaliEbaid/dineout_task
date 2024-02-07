import 'package:dine_out_client/service/menu_tree.dart';
import 'package:dine_out_client/widgets/menu/menu.dart';
import 'package:dine_out_client/widgets/menu/tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/link.dart' as url;
import 'package:url_launcher/url_launcher.dart';

import '../../model/dummy_data.dart';
import '../../model/placeholder_models.dart';
import '../../service/extensions.dart';

/// A widget that displays the details of a restaurant, including its menu.
///
/// The widget displays the restaurant's "metadata" (e.g., name, address, opening hours, etc.)
/// and uses a [RestaurantDetailBodyWidget] to display the menu and tab bar.
class RestaurantDetailWidget extends StatefulWidget {
  /// The ID of the restaurant to display.
  final String restaurantId;

  /// The name of the restaurant to display.
  final String? restaurantName;

  const RestaurantDetailWidget(this.restaurantId, {this.restaurantName, super.key});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantDetailState();
  }
}

class _RestaurantDetailState extends State<RestaurantDetailWidget> {
  /// The future that resolves to the restaurant detail object.
  late final Future<Restaurant> restaurant;

  /// The controller for the scroll view.
  /// This is used to scroll to a category when the user selects it from the tab bar.
  late final AutoScrollController scrollController;

  /// The key for the expandable FAB.
  /// This is used to close the FAB when the user selects an option.
  final fabKey = GlobalKey<ExpandableFabState>();

  /// The name of the restaurant.
  String? restaurantName;

  /// The root of the menu tree.
  MenuTreeRoot? menuTreeRoot;

  @override
  void initState() {
    super.initState();
    restaurantName = widget.restaurantName;
    scrollController = AutoScrollController(axis: Axis.vertical);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Closes the expandable FAB if it is open.
  void closeFab() {
    if (fabKey.currentState?.isOpen ?? false) {
      fabKey.currentState?.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;
    Widget? fab;
    final Restaurant? restaurant = restaurants[widget.restaurantId]; // TODO
    if (restaurant == null) {
      body = const Center(child: Text("Restaurant not found"));
    } else {
      restaurantName ??= restaurant.name;
      final emptyMenu = restaurant.menu.categories.isEmpty;
      if (!emptyMenu) {
        menuTreeRoot ??= MenuTreeRoot(restaurant.menu, includeEmptyCategories: false);
      }
      body = RestaurantDetailBodyWidget(
        restaurant,
        menuTreeRoot,
        scrollController: scrollController,
      );
      fab = ExpandableFab(
        key: fabKey,
        type: ExpandableFabType.up,
        distance: 80.0,
        overlayStyle: ExpandableFabOverlayStyle(blur: 4.0),
        children: [
          if (!emptyMenu)
            FloatingActionButton.extended(
              heroTag: "category",
              onPressed: () async {
                closeFab();
                final int? newIndex = await context.push<int>("/restaurant/${restaurant.id}/categories",
                    extra: (menuTree: menuTreeRoot!, restaurantName: restaurant.name));
                await Future.delayed(const Duration(milliseconds: 400));
                if (mounted && newIndex != null) {
                  // +1 because first element is the "up" state.
                  scrollController.scrollToCategory(newIndex + 1);
                }
              },
              icon: const Icon(Icons.grid_view),
              label: const Text("All Categories"),
            ),
          if (restaurant.coordinates != null)
            FloatingActionButton.extended(
              heroTag: "maps",
              onPressed: () {
                closeFab();
                _launchMaps(restaurant);
              },
              icon: const Icon(Icons.map),
              label: const Text("Google Maps"),
            ),
        ],
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(restaurantName ?? "Restaurant"),
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: fab,
        body: body);
  }

  /// Launches the Google Maps app with the [restaurant]'s location.
  void _launchMaps(Restaurant restaurant) async {
    assert(restaurant.coordinates != null);
    final (double latitude, double longitude) = restaurant.coordinates!;
    final Uri uri = Uri(
        scheme: 'https',
        path: 'www.google.com/maps/dir/',
        queryParameters: {'api': '1', 'destination': '$latitude,$longitude'});
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

/// A widget that displays the body of a restaurant detail page, consisting of the category tab bar and the menu.
class RestaurantDetailBodyWidget extends StatefulWidget {
  /// The restaurant to display.
  final Restaurant restaurant;

  /// The root of the menu tree.
  final MenuTreeRoot? menuTree;

  /// The controller for the scroll view.
  final AutoScrollController scrollController;

  const RestaurantDetailBodyWidget(this.restaurant, this.menuTree, {required this.scrollController, super.key});

  @override
  State<StatefulWidget> createState() {
    return _RestaurantDetailDisplayState();
  }
}

class _RestaurantDetailDisplayState extends State<RestaurantDetailBodyWidget> with TickerProviderStateMixin {
  /// The controller for the tab bar.
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final int rootCategories = widget.menuTree?.categories.length ?? 0;
    _tabController = TabController(length: rootCategories + 1, vsync: this); // +1 due to up arrow
  }

  /// Changes the active tab to the one at [index].
  void _changeActiveTab(int index) {
    if (!_tabController.indexIsChanging) {
      _tabController.animateTo(index + 1);
    }
  }

  /// Wraps the [child] with an [AutoScrollTag], using the given [index] as the tag.
  Widget _wrapItem(Widget child, int index) {
    return AutoScrollTag(
        key: ValueKey(index + 1),
        controller: widget.scrollController,
        index: index,
        highlightColor: Colors.red.withOpacity(0.1),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final tree = widget.menuTree;
    return Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
        child: InViewNotifierCustomScrollView(
            controller: widget.scrollController,
            throttleDuration: const Duration(milliseconds: 100),
            isInViewPortCondition: (double deltaTop, double deltaBottom, double viewPortDimension) {
              // Return true if widget is in top 5–30% of screen
              final percentage = deltaTop / viewPortDimension;
              return percentage < 0.3 && percentage > 0.05;
            },
            slivers: [
              SliverToBoxAdapter(
                child: _wrapItem(
                    Text(restaurant.name,
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                    0),
              ),
              SliverList(
                  delegate: SliverChildListDelegate.fixed([
                Text(
                  "Address: ${restaurant.address.toHumanString()}",
                  textAlign: TextAlign.center,
                ),
                if (restaurant.websiteUrl != null)
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text("Website: "),
                      url.Link(
                          uri: Uri.parse(restaurant.websiteUrl!),
                          builder: (context, followLink) => InkWell(
                              onTap: followLink,
                              child: const Text(
                                "https://some-restaurant.example.com",
                                textAlign: TextAlign.center,
                              )))
                    ],
                  ),
              ])),
              const SliverList(
                  delegate: SliverChildListDelegate.fixed([
                SizedBox(height: 10),
                Divider(),
              ])),
              if (tree != null)
                SliverPersistentHeader(
                  delegate: PersistentMenuTabBar(
                      // We only display root categories in the tab bar.
                      categories: tree.categories.map((e) => e.element).toList(),
                      controller: _tabController,
                      onTabTap: (index) => widget.scrollController.scrollToCategory(index)),
                  pinned: true,
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              if (tree == null)
                const SliverToBoxAdapter(
                    child: Text(
                  "Unfortunately, we do not have a menu for this restaurant yet.",
                  textAlign: TextAlign.center,
                ))
              else
                MenuWidget(
                  tree,
                  onCategoryScrolled: _changeActiveTab,
                  wrapItem: _wrapItem,
                ),
            ]));
  }
}
