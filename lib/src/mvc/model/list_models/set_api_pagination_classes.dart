import 'package:flutter/material.dart';

/// List user upcoming appointments (Set<`Appointment`>):
abstract class SetApiPaginationClasses<T> with ChangeNotifier {
  /// Set of unique `T`.
  Set<T> list = {};

  /// is in init state and requires initialization.
  bool isNull = true;

  /// is awaiting for response from get HTTP request, used to avoid duplicated requests.
  bool isLoading = false;

  /// has error after the last HTTP request
  bool hasError = false;

  /// total number of pages for appointments list.
  int totalPages = -1;

  /// current page.
  int currentPage = 0;

  /// `true` if there are still more pages (pagination).
  bool get hasMore => currentPage < totalPages;

  /// The number of nearby salons in list.
  int get length => list.length;

  bool get isNotNull => !isNull;

  /// `this.list` is empty.
  bool get isEmpty => list.isEmpty;

  /// `this.list` is not empty.
  bool get isNotEmpty => list.isNotEmpty;

  bool get canGetMore => (isNotNull && hasMore && !isLoading);

  T elementAt(int index) => list.elementAt(index);

  /// Init data.
  /// if [callGet] is `true` proceed with query, else break.
  Future<void> initData({
    required bool callGet,
  }) async {
    if (!callGet) return;
    if (!isNull) return;
    if (isLoading) return;
    isLoading = true;
    await get(
      page: currentPage,
      refresh: false,
      update: update,
    );
  }

  /// call get to retrieve data from backend.
  Future<void> get({
    required int page,
    required bool refresh,
    required void Function(Set<T>, int, int, bool, bool) update,
  });

  /// Get more data, uses pagination.
  Future<void> getMore() async {
    if (isNull) return;
    if (isLoading) return;
    isLoading = true;
    await get(
      page: currentPage,
      refresh: false,
      update: update,
    );
  }

  /// Refresh data.
  Future<void> refresh() async {
    if (isLoading) return;
    totalPages = -1;
    currentPage = 0;
    hasError = false;
    isLoading = true;
    await get(
      page: currentPage,
      refresh: true,
      update: update,
    );
  }

  /// Update list with query result, and notify listeners
  void update(
    Set<T> result,
    int totalPages,
    int currentPage,
    bool error,
    bool refresh,
  ) {
    if (error || refresh) {
      list.clear();
    }
    list.addAll(result);
    this.totalPages = totalPages;
    this.currentPage = currentPage;
    isLoading = false;
    isNull = false;
    hasError = error;
    notifyListeners();
  }

  /// Reset list to its initial state.
  void reset() {
    isNull = true;
    isLoading = false;
    hasError = false;
    list.clear();
    totalPages = -1;
    currentPage = 0;
  }

  /// Clone the values of all attributs of [update] to `this` and refresh the UI.
  /// The aim here is to update to `this` and keep all widgets attached to `this` notifiable.
  void updateFrom(SetApiPaginationClasses<T> update) {
    list = update.list;
    isNull = update.isNull;
    isLoading = update.isLoading;
    totalPages = update.totalPages;
    currentPage = update.currentPage;
    hasError = update.hasError;
    notifyListeners();
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has reached the end of the
  ///page, and if the list has more data, call `getMore`.
  bool onMaxScrollExtent(ScrollNotification scrollNotification) {
    if (!canGetMore) return true;
    if (scrollNotification.metrics.pixels !=
        scrollNotification.metrics.maxScrollExtent) {
      return true;
    }
    getMore();
    return true;
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll is
  ///[extentAfter] away from the end of the page, and if the list has more data,
  /// call `getMore`.
  bool onExtentAfter(
    ScrollNotification scrollNotification,
    double extentAfter,
  ) {
    if (!canGetMore) return true;
    if (scrollNotification.metrics.extentAfter < extentAfter) {
      return true;
    }
    getMore();
    return true;
  }
}
