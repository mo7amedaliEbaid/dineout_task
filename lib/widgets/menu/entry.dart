import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../model/placeholder_models.dart';
import '../../service/constants.dart';

/// A mixin that provides icons and price text for a menu entry.
///
/// Entries may be shown in different contexts, such as in a list or in a detail view,
/// hence the mixin was added to avoid code duplication for these cases.
mixin EntryDescriptor {
  /// The menu entry described by this mixin.
  Entry get entry;

  /// Returns a list of icons that represent the properties of the menu entry.
  List<Widget> getIcons() {
    final List<Widget> icons = [];
    if (entry.vegan) {
      icons.add(const Tooltip(message: "Vegan", child: FaIcon(veganIcon, color: Colors.green)));
    } else if (entry.vegetarian) {
      icons.add(const Tooltip(message: "Vegetarian", child: FaIcon(vegetarianIcon, color: Colors.lightGreen)));
    }
    if (entry.forKids) {
      icons.add(const Tooltip(message: "For kids", child: Icon(forKidsIcon)));
    }
    return icons;
  }

  /// Returns the price text for the menu entry.
  String getPriceText() {
    String priceText = "";
    final double? minPrice = entry.prices.minOrNull;
    if (minPrice != null) {
      priceText = NumberFormat.simpleCurrency(name: "EUR").format(minPrice);
      final double maxPrice = entry.prices.max;
      if (minPrice != maxPrice) {
        priceText += " – ${NumberFormat.simpleCurrency(name: "EUR").format(maxPrice)}";
      }
    }
    return priceText;
  }
}

/// A widget that displays a menu entry.
class MenuEntryWidget extends StatefulWidget with EntryDescriptor {
  @override
  final Entry entry;

  /// The ID of the menu to which this entry belongs.
  final String menuId;

  /// The background color of the widget.
  final Color? backgroundColor;

  const MenuEntryWidget(this.entry, {required this.menuId, this.backgroundColor, super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenuEntryWidgetState();
  }
}

class _MenuEntryWidgetState extends State<MenuEntryWidget> {
  /// The background color of the widget.
  late Color backgroundColor;

  @override
  void initState() {
    backgroundColor = widget.backgroundColor ?? Colors.white;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String priceText = widget.getPriceText();
    Widget? description;
    // The comparison to true may seem weird, but it is necessary because the description may be null.
    if (widget.entry.description.trim().isNotEmpty == true) {
      description = Text(widget.entry.description.trim(), maxLines: 2, overflow: TextOverflow.ellipsis);
    }
    final List<Widget> belowDescription = widget.getIcons();
    bool needsSubtitle = description != null || belowDescription.isNotEmpty;

    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: backgroundColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: InkWell(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: ListTile(
                  title: Text(widget.entry.name),
                  leading: placeholderImages
                      ? const SizedBox(width: 50, child: Placeholder(fallbackHeight: 10, fallbackWidth: 10))
                      : null,
                  subtitle: needsSubtitle
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          if (description != null) description,
                          if (description != null && belowDescription.isNotEmpty) const SizedBox(height: 5),
                          if (belowDescription.isNotEmpty)
                            Wrap(spacing: 10, crossAxisAlignment: WrapCrossAlignment.center, children: belowDescription)
                        ])
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(priceText),
                    ],
                  ),
                ))));
  }
}
