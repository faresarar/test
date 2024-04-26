import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main.dart';
import '../../../../settings/preferences.dart';
import '../../../../settings/settings_controller.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/change_notifiers.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.userSession,
    required this.settingsController,
    required this.initialLink,
  });

  final UserSession userSession;
  final SettingsController settingsController;
  final PendingDynamicLinkData? initialLink;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  NotifierInt pageNotifier = NotifierInt(1);
  // NotifierInt notifierMessages = NotifierInt(-1);
  // late Stream<bool> streamNotifications;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // streamNotifications = AppNotificationsService.listenNotifications(
    //   widget.user.uid,
    // );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.initialLink != null) {
        handleDynamicLinkData(widget.initialLink!);
      }
      await initMessagesNotifier();
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message == null) return;
      log('getInitialMessage');
    });

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        if (!kIsWeb) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@drawable/logo_notif',
                channelShowBadge: true,
                importance: Importance.max,
                playSound: true,
                priority: Priority.max,
                visibility: NotificationVisibility.public,
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      onMessage,
      onDone: () {
        log('onMessage->onDone');
      },
    );
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onOpenMessage(
        message.data['key'],
        message.data,
        true,
      );
    });
  }

  // @override
  // void deactivate() {
  //   try {
  //     CacheUsersPresence.closeAllStreams();
  //   } catch (e) {
  //     //todo
  //   }
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: pageNotifier,
      builder: (context, currentPage, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: CustomDrawer(
            parentContext: context,
            userSession: widget.userSession,
            pageNotifier: pageNotifier,
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            scaffoldKey: _scaffoldKey,
            pageNotifier: pageNotifier,
          ),
          body: Builder(
            builder: (context) {
              switch (currentPage) {
                case 1:
                  return MainScreenPage1(userSession: widget.userSession);
                case 2:
                  return MainScreenPage2(userSession: widget.userSession);
                case 3:
                  return MainScreenPage3(userSession: widget.userSession);
                default:
                  throw UnimplementedError();
              }
            },
          ),
        );
      },
    );
  }

  Future<void> initMessagesNotifier({bool refresh = false}) async {
    // if ((notifierMessages.value < 0) || (refresh)) {
    //   notifierMessages.setValue(
    //     await ChatsService.hasUnreadMessages(
    //       widget.user.uid,
    //     ),
    //   );
    // }
  }

  Future<void> onBackgroundMessage(RemoteMessage message) async {
    log('onBackgroundMessage->${message.data}');
  }

  ///Trigger this code when a new message is recieved, without clicking on it
  void onMessage(RemoteMessage message) {
    log('onMessage->${message.data}');
    switch (message.data['key']) {
      case 'new_message':
        initMessagesNotifier(refresh: true);
        break;
      default:
    }
  }

  Future<void> onOpenMessage(
    String key,
    Map<String, dynamic> data, [
    bool isOnFirstRoot = true,
    void Function(Exception)? onError,
  ]) async {
    try {
      FocusScope.of(context).unfocus();
      if (isOnFirstRoot) Navigator.popUntil(context, (route) => route.isFirst);
      switch (key) {
        default:
          return;
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'document-not-found':
          context.showSnackBar(
            'document_not_found',
          );
          // appNotification.delete();
          break;
        default:
          rethrow;
      }
    } on Exception {
      context.showSnackBar(
        'unknown_error',
      );
    }
  }

  void handleDynamicLinkData(PendingDynamicLinkData dynamicLinkData) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Dialogs.of(context).runAsyncAction<dynamic>(
      future: () async {
        switch (dynamicLinkData.link.path) {
          case DynamicLinksService.invite:
            await Future.delayed(const Duration(milliseconds: 500));
          // return await CachePosts.getById(
          //   postId: dynamicLinkData.link.queryParameters['id']!,
          //   uid: widget.user.uid,
          // );
          default:
        }
      },
      onComplete: (doc) {
        // if (doc is Post) {
        // } else {
        //   throw Exception();
        // }
      },
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          context.showSnackBar(
            e.code,
          );
        } catch (e) {
          context.showSnackBar(
            'unknown_error',
          );
        }
      },
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.pageNotifier,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final NotifierInt pageNotifier;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (page) {
        if (page == 0) {
          _scaffoldKey.currentState!.openDrawer();
          return;
        }
        pageNotifier.setValue(page);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: context.scaffoldBackgroundColor,
      elevation: 10,
      selectedItemColor: context.primary,
      selectedIconTheme: IconThemeData(
        size: 24.sp,
        color: context.primary,
      ),
      showSelectedLabels: false,
      unselectedItemColor: context.b1,
      unselectedIconTheme: IconThemeData(
        size: 24.sp,
        color: context.b1,
      ),
      showUnselectedLabels: false,
      currentIndex: pageNotifier.value,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            AwesomeIconsRegular.bars_sort,
          ),
          activeIcon: Icon(
            AwesomeIconsRegular.bars_sort,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AwesomeIconsLight.home,
          ),
          activeIcon: Icon(
            AwesomeIconsSolid.home,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AwesomeIconsLight.rectangle_history,
          ),
          activeIcon: Icon(
            AwesomeIconsSolid.rectangle_history,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            AwesomeIconsLight.circle_user,
          ),
          activeIcon: Icon(
            AwesomeIconsSolid.circle_user,
          ),
          label: '',
        ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.parentContext,
    required this.userSession,
    required this.pageNotifier,
  });

  final BuildContext parentContext;
  final UserSession userSession;
  final NotifierInt pageNotifier;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 0.85.sw,
      child: Column(
        children: [
          //Header
          Container(
            color: context.primary,
            padding: EdgeInsetsDirectional.fromSTEB(
              24.w,
              context.viewPadding.top + 24.h,
              24.w,
              context.viewPadding.bottom + 24.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40.sp,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 37.sp,
                    backgroundColor: context.primaryColor[50],
                    foregroundImage: userSession.photo ??
                        Image.asset('assets/images/avatar.png').image,
                  ),
                ),
                16.widthW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userSession.firstName.isNotNullOrEmpty)
                        Text(
                          userSession.firstName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.h3b1.copyWith(color: Colors.white),
                        ),
                      Text(
                        userSession.email!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h5b1.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //List tile
          Padding(
            padding: EdgeInsetsDirectional.all(24.w),
            child: Column(
              children: [
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.user_doctor,
                  title: 'Mon compte',
                  hasNotification: userSession.isProfileNotComplete,
                  onTap: () => pageNotifier.setValue(3),
                  autoPop: true,
                ),
                if (userSession.isReviewedApp != true)
                  CustomMenuListTile(
                    icon: AwesomeIconsRegular.star_half_stroke,
                    title: 'Laisser un avis',
                    onTap: () async {
                      await Dialogs.of(parentContext).runAsyncAction(
                        future: () async {
                          //FIXME setup RateMyApp
                          await RateMyApp(
                            preferencesPrefix: 'rateMyApp_',
                            minDays: 0,
                            minLaunches: 3,
                            remindDays: 7,
                            remindLaunches: 10,
                            googlePlayIdentifier: 'com.vitafit.app',
                            appStoreIdentifier: '',
                          ).launchStore();
                          await userSession.updateIsReviewed();
                        },
                      );
                    },
                    autoPop: true,
                  ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.hashtag,
                  title: 'Conditions d\'utilisation',
                  onTap: () => launchUrl(
                    Uri.parse(Preferences.cguUrl),
                  ),
                  autoPop: true,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.file_signature,
                  title: 'Politique de confidentialité',
                  onTap: () => launchUrl(
                    Uri.parse(Preferences.policyUrl),
                  ),
                  autoPop: true,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.share,
                  title: 'Partager',
                  onTap: () => Dialogs.of(parentContext).runAsyncAction<Uri>(
                    future: () async {
                      return await DynamicLinksService.buildInvitDynamicLink(
                        title: 'Télécharger VitaFit',
                        description: 'Télécharger VitaFit',
                        photoUrl:
                            'https://firebasestorage.googleapis.com/v0/b/get-pansia-dev.appspot.com/o/files%2Flogo-cropped.png?alt=media&token=6b224e93-fab8-4748-92b0-d228a466d63d',
                      );
                    },
                    onComplete: (uri) {
                      if (uri == null) return;
                      Share.shareUri(uri);
                    },
                  ),
                  autoPop: true,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.lightbulb_on,
                  title: 'Idées d\'amélioration',
                  onTap: () => context.push(
                    widget: SubmitUserFeedback(
                      userSession: userSession,
                    ),
                  ),
                  autoPop: true,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.arrow_right_from_bracket,
                  title: 'Se déconnecter',
                  color: Styles.red,
                  onTap: () => Dialogs.of(parentContext).showAlertDialog(
                    dialogState: DialogState.confirmation,
                    subtitle: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                    onContinue: () => Dialogs.of(parentContext).runAsyncAction(
                      future: userSession.signOut,
                    ),
                    continueLabel: 'Se déconnecter',
                  ),
                  autoPop: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
