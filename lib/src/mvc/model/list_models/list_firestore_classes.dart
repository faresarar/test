import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

abstract class ListFirestoreClasses<T> with ChangeNotifier {
  final String uid;
  List<T> list = [];
  bool isNull = true;
  bool isLoading = false;
  DocumentSnapshot? lastDoc;
  bool hasMore = false;
  int limit;

  ListFirestoreClasses({
    required this.uid,
    required this.limit,
  });

  /// Update `list` with the data fetched from the database. The results include:
  ///
  /// - [resultList] List of `T` elements retrieved from the database.
  ///
  /// - [resultHasMore] if the result has more that `limit` results, meaning it
  /// is possible that there are still data for pagination.
  ///
  /// - [resultLastDoc] is the last document in the result. Used as a reference
  /// for pagination to fetch more documents if needed.
  ///
  /// - [refresh] if this is set to `true`, reset all old data and replace it with this result.
  void updateList(
    List<T> resultList,
    bool resultHasMore,
    DocumentSnapshot? resultLastDoc,
    bool refresh,
  ) {
    if (refresh) {
      list.clear();
    }
    list.addAll(resultList);
    hasMore = resultHasMore;
    lastDoc = resultLastDoc;
    isNull = false;
    isLoading = false;
    notifyListeners();
  }

  /// Insert [element] into `list` and notify all listeners.
  void insert(T element) {
    if (isNull) return;
    List<T> newList = [element, ...list];
    list.clear();
    list = newList;
    notifyListeners();
  }

  /// Create [element] in the database and insert it into `list`, and notify all listeners.
  Future<void> create(T element);

  /// Removes all objects from this list that satisfy [test].
  Future<void> removeWhere(bool Function(T) test) async {
    if (list.isEmpty || isNull) return;
    list.removeWhere(test);
    if (hasMore) {
      await getMore(
        want: 1,
      );
    }
    notifyListeners();
  }

  /// Remove [element] from `list` and notify all listeners.
  Future<void> remove(T element) async {
    if (list.isEmpty || isNull) return;
    list.remove(element);
    if (hasMore) {
      await getMore(want: 1);
    }
    notifyListeners();
  }

  /// Delete [element] from the database and also remove it from `list`, and notify all listeners.
  Future<void> delete(T element);

  /// Use this method to fetch data from the database, weather for the first call or when calling `getMore`.
  ///
  /// - [refresh] set to true when refreshing data in this class.
  ///
  /// - [get] set to true to allow this function to make a get call to the
  /// database, else the call will be skipped. This is used to make sure that
  /// we only make a request to Firestore database when the UI is visible.
  Future<void> get({bool refresh = false, bool get = true});

  /// Refresh data.
  Future<void> refresh() async {
    await get(
      get: true,
      refresh: true,
    );
  }

  /// get more results and manage pagination.
  ///
  /// set [want] to the number of documents you want to retrieve. For instance,
  /// after removing or deleting an element from `list`, you want to retrieve
  /// one more document to keep the list scrollable, and in this case set `want = 1`.
  Future<void> getMore({
    int? want,
  });

  void reset() {
    list.clear();
    isNull = true;
    isLoading = false;
    hasMore = false;
    lastDoc = null;
    notifyListeners();
  }

  /// return `true` if the list is empty
  bool get isEmpty => list.isEmpty && !isNull;

  /// return `true` if the list is not empty
  bool get isNotEmpty => list.isNotEmpty;

  /// return `true` if the list is not null
  bool get isNotNull => !isNull;

  /// return the `length` of `list`
  int get length => list.length;

  /// return the `childCound` forf `list`, specifically when adding a seperator to list view
  int get childCount => (list.length * 2) - 1;

  /// return `true` if there are still documents to be retrieved from the database
  bool get canGetMore => (isNotNull && hasMore && !isLoading);

  T elementAt(int index) => list.elementAt(index);

  bool isAwaiting({
    /// set to `true` if the call is a refresh request
    required bool refresh,

    ///if set to `true` to allow the request to pass to firebase, else set to `false` to skip call
    required bool get,

    ///set to `true` only in getMore calls
    required bool isGetMore,
  }) {
    if (!isGetMore && !refresh && (!get || isNotNull || isLoading)) {
      return true;
    }
    isLoading = true;
    return false;
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll has
  ///reached the end of the page, and if the list has more data, call `getMore`.
  ///if [muteScrollNotification] is set to true, mute scroll notification in the
  ///widget tree, else notify top-level widgets.
  bool onMaxScrollExtent(
    ScrollNotification scrollNotification, [
    bool muteScrollNotification = false,
  ]) {
    if (isNull) return !muteScrollNotification;
    if (isLoading) return !muteScrollNotification;
    if (!canGetMore) return !muteScrollNotification;
    if (scrollNotification.metrics.pixels !=
        scrollNotification.metrics.maxScrollExtent) {
      return !muteScrollNotification;
    }
    getMore();
    return !muteScrollNotification;
  }

  ///For lazzy loading, Use [scrollNotification] to detect if the scroll is
  ///[extentAfter] away from the end of the page, and if the list has more data,
  /// call `getMore`. if [muteScrollNotification] is set to true, mute scroll
  /// notification in the widget tree, else notify top-level widgets.
  bool onExtentAfter(
    ScrollNotification scrollNotification,
    double extentAfter, [
    bool muteScrollNotification = false,
  ]) {
    if (isNull) return !muteScrollNotification;
    if (isLoading) return !muteScrollNotification;
    if (!canGetMore) return !muteScrollNotification;
    if (scrollNotification.metrics.extentAfter < extentAfter) {
      return !muteScrollNotification;
    }
    getMore();
    return !muteScrollNotification;
  }

  /// Add listener to [controller] to listen for pagination and load more results
  /// if there are any.
  void addControllerListener(ScrollController controller) {
    controller.addListener(() {
      if (isNull) return;
      if (isLoading) return;
      if (!canGetMore) return;
      if (controller.position.maxScrollExtent != controller.offset) return;
      getMore();
    });
  }
}
