extension SetExtension<T> on Set<T> {
  ///insert [value] where [test] defines the unique value in the `Set`. if
  ///[overwrite] is set to true, remove any occurence and add the element anyways.
  ///return `true`if [value] was inserted, else return `false`.
  bool insertWhere(
    T value, {
    required bool Function(T) test,
    bool overwrite = false,
  }) {
    if (overwrite) {
      removeWhere(test);
      add(value);
      return true;
    } else if (where(test).isEmpty) {
      add(value);
      return true;
    } else {
      return false;
    }
  }

  /// takes elements from [result] and return only the elements that does not satisfy [test].
  ///
  /// Example:
  /// ```dart
  /// final numbers = {1, 2, 3, 5, 6, 7};
  /// final result = {1, 3, 9};
  /// var addedValues = numbers.comparesWith(result, (elementSet, elementResult) => elementSet == elementResult); // {9};
  /// var existingValues = numbers.comparesWith(result, (elementSet, elementResult) => elementSet != elementResult); // {1, 3};
  /// ```
  Set<T> comparesWith(
    Set<T> result,
    bool Function(T, T) test,
  ) {
    Set<T> changes = {};
    for (var element in result) {
      if (!any((x) => test(x, element))) {
        add(element);
        changes.add(element);
      }
    }
    return changes;
  }
}
