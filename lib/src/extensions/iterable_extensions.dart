extension IterableExtensions<T> on Iterable<T> {
  ///Merge two iterables `this` and [elements] into one. Mainly used to create a `TextSpam`
  ///for `RichText` widget from the result, after splitting a String and applying the appropriate text style on the matches of a RegExp.
  Iterable<T> zip(Iterable<T> elements) sync* {
    final ita = iterator;
    final itb = elements.iterator;
    bool hasa, hasb;
    while ((hasa = ita.moveNext()) | (hasb = itb.moveNext())) {
      if (hasa) yield ita.current;
      if (hasb) yield itb.current;
    }
  }
}
