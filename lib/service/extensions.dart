import 'package:collection/collection.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../model/placeholder_models.dart';

extension HumanString on Address {
  String toHumanString() {
    String result = "${street.trim()}, $plz ${locality?.trim() ?? ""}";
    if (comment != null) {
      result += " (${comment?.trim()})";
    }
    return result;
  }
}

extension IterableNullHelper<T extends Object> on Iterable<T?>? {
  List<T> nonNullChildren() {
    return this?.whereNotNull().toList() ?? [];
  }
}

extension ScrollToCategory on AutoScrollController {
  void scrollToCategory(int index) {
    if (index == 0) {
      scrollToIndex(0, preferPosition: AutoScrollPosition.middle);
    } else {
      scrollToIndex(index, preferPosition: AutoScrollPosition.begin);
      highlight(index, cancelExistHighlights: true, highlightDuration: const Duration(milliseconds: 1500));
    }
  }
}
