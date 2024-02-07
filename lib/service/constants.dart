import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Icon representing a vegetarian meal.
const IconData vegetarianIcon = FontAwesomeIcons.leaf;

// Icon representing a vegan meal.
const IconData veganIcon = FontAwesomeIcons.seedling;

/// Icon representing a meal for kids.
const IconData forKidsIcon = Icons.child_care;

/// Icon representing an entry.
const entryIcon = Icon(Icons.food_bank_outlined);

/// Icon representing a meal.
const mealIcon = Icon(Icons.restaurant_outlined);

/// Icon representing a restaurant.
const restaurantIcon = Icon(Icons.storefront_outlined);

/// Whether placeholder images should be used.
const bool placeholderImages = false;

/// Whether the app is running on a supported platform.
final supportedPlatform = kIsWeb || Platform.isAndroid || Platform.isIOS;
