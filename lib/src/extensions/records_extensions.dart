extension Overlap on (int, int) {
  /// return `true` if [`this.$1`, `this.$2`] overlaps [`pair.$1`, `pair.$2`].
  bool doesNotOverlap((int, int) pair) {
    return this.$1 >= pair.$2 || this.$2 <= pair.$1;
  }
}

extension Ranges on List<(int, int)> {
  /// inside this list of records, merge any records that overlap or complete eachother.
  void merge({bool sort = false}) {
    List<(int, int)> sortedRanges = this;
    if (sort) {
      // Sort the ranges by start value
      sortedRanges = this..sort((a, b) => a.$1.compareTo(b.$1));
    }

    // Initialize the mergedRanges list with the first range
    List<(int, int)> mergedRanges = [sortedRanges.first];

    for (int i = 1; i < sortedRanges.length; i++) {
      (int, int) currentRange = sortedRanges[i];
      (int, int) lastMergedRange = mergedRanges.last;

      if (currentRange.$1 <= lastMergedRange.$2) {
        // Ranges overlap or are adjacent, merge them
        int mergedEnd = currentRange.$2 > lastMergedRange.$2
            ? currentRange.$2
            : lastMergedRange.$2;

        mergedRanges[mergedRanges.length - 1] = (lastMergedRange.$1, mergedEnd);
      } else {
        // Ranges don't overlap, add the current range to mergedRanges
        mergedRanges.add(currentRange);
      }
    }

    clear();
    addAll(mergedRanges);
  }
}
