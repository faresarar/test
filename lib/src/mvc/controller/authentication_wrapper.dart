import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_controller.dart';
import '../../tools.dart';
import '../model/change_notifiers.dart';
import '../model/models.dart';
import '../view/screens.dart';

/// This class is responsable for data flow down the widget tree as well as managing which widget is displayed including:
/// - `SplashScreen`: displayed when the data is still being prepared and the app is still not ready for use,
/// - `UpdateScreen`: displayed when the remote config indicates that there is a new update for the app
/// - `BreakScreen`: displayed when the remote config indicates that the app or our servers are under maintenance
/// - `MainScreen`: displayed when non of the above conditions are satisfied
class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({
    super.key,
    required this.settingsController,
    required this.showSplashScreen,
    required this.hideSplashScreen,
  });

  /// settings controller
  final SettingsController settingsController;

  /// used to avoid rebuilding the splash screen, which may cause the animation to repeat multiple times
  final bool showSplashScreen;

  /// used to disable rebuilding the splash screen when the AuthWrapper rebuilds
  final void Function() hideSplashScreen;

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  late bool showSplashScreen;
  RemoteConfigNotifier remoteConfigNotifier = RemoteConfigNotifier();
  Set<String> imagesAssets = {};
  Set<String> svgAssets = {};

  @override
  void initState() {
    super.initState();
    showSplashScreen = widget.showSplashScreen;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!context.mounted) return;
      remoteConfigNotifier.init(context);
      precacheImages(context);
      Paddings.init(context);
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (context.mounted) {
            setState(() {
              widget.hideSplashScreen();
              showSplashScreen = false;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: remoteConfigNotifier,
      child: Consumer2<UserSession, RemoteConfigNotifier>(
        builder: (context, userSession, remoteConfig, _) {
          if (userSession.isAwaiting || showSplashScreen) {
            return SplashScreen(userSession: userSession);
          }
          //Firebase remote config
          if (remoteConfig.isNotReady ||
              remoteConfig.requireUpdate == true ||
              remoteConfig.requireBreak) {
            return SplashScreen(userSession: userSession);
          }

          if (widget.settingsController.showOnboarding) {
            return Onboarding(settingsController: widget.settingsController);
          }
          if (userSession.isUnauthenticated ||
              (userSession.isAuthenticated &&
                  userSession.emailVerified == false)) {
            return AuthenticationRouter(
              userSession: userSession,
              settingsController: widget.settingsController,
            );
          }
          return MainScreen(
            userSession: userSession,
            settingsController: widget.settingsController,
            initialLink: null,
          );
        },
      ),
    );
  }

  /// add images in `imagesAssets` and `svgAssets` to cache for faster load times.
  Future<bool> precacheImages(BuildContext context) async {
    for (var imagePath in imagesAssets) {
      await precacheImage(AssetImage(imagePath), context);
    }
    imagesAssets.clear();
    for (var svgPath in svgAssets) {
      // ignore: use_build_context_synchronously
      await precachePicture(
        ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder,
          svgPath,
        ),
        context.mounted ? context : null,
      );
    }
    svgAssets.clear();
    return true;
  }
}
