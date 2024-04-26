import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../tools.dart';

class DynamicLinksService {
  final BuildContext context;

  DynamicLinksService(this.context);

  static DynamicLinksService of(BuildContext context) {
    assert(context.mounted);
    return DynamicLinksService(context);
  }

  static const String baseUrl = 'https://vitafit.page.link';
  static const String invite = '/invites';

  ///Build long link to private information
  static Future<Uri> buildInvitDynamicLink({
    required String title,
    required String description,
    required String photoUrl,
  }) async {
    // return Uri.parse('$baseUrl$invite');
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('$baseUrl$invite'),
      uriPrefix: baseUrl,
      androidParameters: const AndroidParameters(
        packageName: 'com.vitafit.app',
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.ios.skeleton_dev',
        appStoreId: 'bundle_id', //TODO use bundle id
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: Uri.parse(photoUrl),
      ),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl;
  }

  Future<void> createDynamicLink({
    required Future<Uri> Function() createLink,
  }) async {
    await Dialogs.of(context).runAsyncAction(
      future: createLink,
      onComplete: (uri) => Share.share(
        uri.toString(),
        // subject: subject,
        // sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}
