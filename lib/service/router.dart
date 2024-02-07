import 'package:dine_out_client/service/types.dart';
import 'package:dine_out_client/widgets/menu/categories.dart';
import 'package:dine_out_client/widgets/menu/restaurant.dart';
import 'package:go_router/go_router.dart';

import '../widgets/home.dart';

GoRouterRedirect _checkType<T>([String? defaultUrl]) {
  return (context, state) async {
    final extra = state.extra;
    if (extra is T) {
      return null;
    }
    if (defaultUrl != null) {
      return defaultUrl;
    }
    if (state.pathParameters.containsKey('restaurantId')) {
      return '/restaurant/${state.pathParameters['restaurantId']}';
    }
    return '/';
  };
}

final router = GoRouter(initialLocation: '/', routes: [
  GoRoute(path: '/', builder: (context, state) => const HomePage(), routes: [
    GoRoute(
        path: 'restaurant/:restaurantId',
        builder: (context, state) => RestaurantDetailWidget(state.pathParameters['restaurantId']!),
        routes: [
          GoRoute(
              path: 'categories',
              redirect: _checkType<CategoryOverviewParameters>(),
              builder: (context, state) {
                final CategoryOverviewParameters extra = state.extra as CategoryOverviewParameters;
                return CategoryOverviewWidget(menuTree: extra.menuTree, restaurantName: extra.restaurantName);
              })
        ]),
  ]),
]);
