import 'package:flutter/material.dart';

import '../model/dummy_data.dart';
import '../model/placeholder_models.dart';
import 'menu/restaurant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Sample Restaurants"),
      ),
      body: ListView(
        children: <Widget>[
          for (Restaurant restaurant in restaurants.values)
            ListTile(
              title: Text(restaurant.name),
              subtitle: Text(restaurant.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantDetailWidget(restaurant.id, restaurantName: restaurant.name),
                  ),
                );
              },
            )
        ],
      ),
    );
  }
}
