/// Decoder
class QueryStringDecoder {
  /// Create a new [Decoder].
  QueryStringDecoder();

  /// Decode [src].
  Map decode(String src) {
    final p = Uri.splitQueryString(src);
    final m = {};
    p.forEach((key, value) {
      final paths = key.split('.').map((e) => e.toCamelCase()).toList();
      final indexes = paths.map((e) => int.tryParse(e)).toList();
      dynamic last = m;
      var lastKey = paths.last;

      for (var i = 0; i < paths.length - 1; i++) {
        final currentKey = paths[i];
        final currentIndex = indexes[i];
        final nextIndex = indexes[i + 1];
        final isCurrentList = currentIndex != null;
        final isNextList = nextIndex != null;

        String? next;
        final k = isCurrentList ? currentIndex : currentKey;
        if (isCurrentList) {
          next = (last as List).length > currentIndex ? last[currentIndex] : null;
        } else {
          next = last[currentKey];
        }

        if (next == null) {
          if (isCurrentList) {
            (last as List).insert(currentIndex, isNextList ? [] : {});
          } else {
            last[currentKey] = isNextList ? [] : {};
          }
          next = last[k];
        }

        if (next is! Map && !isNextList || next is! List && isNextList) {
          throw Exception('conflict key: $currentKey, with $currentKey');
        }

        last = last[k];
      }

      var obj = last[lastKey];
      if (obj == null) {
        last[lastKey] = [value];
        return;
      }
      if (obj is List) {
        obj.add(value);
        return;
      }
      throw Exception('conflict key: $key, with $lastKey');
    });
    return m;
  }
}

extension Case on String {
  String toSnakeCase() {
    return RegExp(r'([a-z]+)|([A-Z][a-z]*)|([0-9]+)').allMatches(this).map((e) => e[0]?.toLowerCase()).join('_');
  }

  String toCamelCase() {
    return splitMapJoin(
      RegExp(r'([a-z]+)|([A-Z][a-z]*)|([0-9]+)'),
      onMatch: (match) => '${match[0]?.upperFirst()}',
      onNonMatch: (str) => '',
    ).lowerFirst();
  }

  String upperFirst() {
    if (isEmpty) {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String lowerFirst() {
    if (isEmpty) {
      return '';
    }
    return '${this[0].toLowerCase()}${substring(1)}';
  }
}
