import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../extensions.dart';
import '../../model/list_models.dart';
import '../model_widgets.dart';

class FirestoreSliverSetView<T> extends StatelessWidget {
  const FirestoreSliverSetView({
    super.key,
    required this.list,
    required this.emptyTitle,
    required this.emptySubtitle,
    this.emptyIconData,
    required this.builder,
    this.seperator,
    this.physics,
    this.padding,
  });

  final ListFirestoreClasses<T> list;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData? emptyIconData;
  final Widget Function(BuildContext, int, T, ListFirestoreClasses<T>) builder;
  final Widget? seperator;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: list,
      child: Consumer<ListFirestoreClasses<T>>(
        builder: (context, list, _) {
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) => list.onExtentAfter(
              scrollNotification,
              0.4.sh,
            ),
            child: NotificationListener<ScrollNotification>(
              onNotification: list.onMaxScrollExtent,
              child: RefreshIndicator(
                onRefresh: list.refresh,
                color: context.primary,
                backgroundColor: context.primaryColor.shade50,
                child: CustomScrollView(
                  physics: physics,
                  slivers: [
                    if (list.isNull && list.isLoading)
                      const CustomLoadingIndicator(
                        isSliver: true,
                      ),
                    if (list.isEmpty)
                      CustomEmptyListView(
                        iconData: emptyIconData,
                        title: emptyTitle,
                        subtitle: emptySubtitle,
                        isSliver: true,
                      ),
                    if (list.isNotEmpty)
                      SliverPadding(
                        padding: padding ??
                            EdgeInsets.symmetric(
                              vertical: 15.sp,
                              horizontal: 20.sp,
                            ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Builder(
                              builder: (context) {
                                if (seperator == null) {
                                  return builder(
                                    context,
                                    index,
                                    list.elementAt(index),
                                    list,
                                  );
                                }
                                if (index.isEven) {
                                  var i = index ~/ 2;
                                  return builder(
                                    context,
                                    i,
                                    list.elementAt(i),
                                    list,
                                  );
                                }
                                return seperator!;
                              },
                            ),
                            childCount: seperator != null
                                ? list.childCount
                                : list.length,
                          ),
                        ),
                      ),
                    CustomTrailingTile(
                      isNotNull: list.isNotNull,
                      isLoading: list.isLoading,
                      hasMore: list.hasMore,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
