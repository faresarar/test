import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../extensions.dart';
import '../../../model/models_ui.dart';
import '../../dialogs.dart';

class MenuDialog extends StatelessWidget {
  const MenuDialog({
    super.key,
    required this.items,
  });

  final List<ModelTextButton> items;

  @override
  Widget build(BuildContext context) {
    assert(items
        .where(
          (element) => element.icon == null || element.onPressed == null,
        )
        .isEmpty);
    return AdaptiveBottomSheet(
      mainAxisSize: MainAxisSize.min,
      continueButton: null,
      cancelButton: null,
      children: [
        16.heightSp,
        ...items
            .map((e) => MenuItemTile(
                  item: e,
                ))
            .toList(),
      ],
    );
  }
}

class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.item,
  });

  final ModelTextButton item;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        context.pop();
        item.onPressed!();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(item.icon, size: 20.sp, color: item.color),
            20.widthSp,
            Text(
              item.label,
              style: (item.style ?? context.h4b1).copyWith(
                color: item.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
