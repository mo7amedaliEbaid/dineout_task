// NOTE: In the actual DineOut app, we use GraphQL-based models.
//       These are just placeholders for the purposes of this task,
//       so the code quality here is rather poor in places.
//       This is also why all models are just dumped into this single file.

import 'package:dine_out_client/service/types.dart';

class BaseModel {
  final String id;

  const BaseModel(this.id);
}

class Restaurant extends BaseModel {
  final String name;
  final String description;
  final Address address;
  final Coordinates? coordinates;
  final String? websiteUrl;
  final Menu menu;

  const Restaurant(super.id, this.name, this.description, this.address, this.coordinates, this.websiteUrl, this.menu);
}

class Address extends BaseModel {
  final String street;
  final String plz; // Basically a zip code
  final String? locality;
  final String? comment;

  const Address(super.id, this.street, this.plz, this.locality, this.comment);
}

class Menu extends BaseModel {
  final List<Category> categories;

  const Menu(super.id, this.categories);
}

class Category extends BaseModel {
  final String name;
  final List<Entry> entries;
  final Category? baseCategory;

  const Category(super.id, this.name, this.entries, this.baseCategory);
}

class Entry extends BaseModel {
  final String name;
  final String description;
  final bool vegan;
  final bool vegetarian;
  final bool forKids;
  final List<double> prices;

  const Entry(super.id, this.name, this.description, this.vegan, this.vegetarian, this.forKids, this.prices);
}
