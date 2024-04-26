import 'package:flutter/material.dart';

import '../../../../settings/settings_controller.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class AuthenticationRouter extends StatefulWidget {
  const AuthenticationRouter({
    super.key,
    required this.userSession,
    required this.settingsController,
  });

  final UserSession userSession;
  final SettingsController settingsController;

  @override
  State<AuthenticationRouter> createState() => _AuthenticationRouterState();
}

class _AuthenticationRouterState extends State<AuthenticationRouter> {
  late ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  void initState() {
    if (widget.userSession.isAuthenticated) {
      authRouteNotifier = ValueNotifier<AuthRoute>(AuthRoute.activation);
    } else {
      authRouteNotifier = ValueNotifier<AuthRoute>(AuthRoute.register);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authRouteNotifier,
      builder: (context, authRoute, _) {
        switch (authRoute) {
          case AuthRoute.register:
            return Register(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
            );
          case AuthRoute.signin:
            return Signin(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
            );
          case AuthRoute.activation:
            return AccountActivation(
              userSession: widget.userSession,
              authRouteNotifier: authRouteNotifier,
            );
          default:
            throw UnimplementedError('AuthRoute switch case not handeled.');
        }
      },
    );
  }
}
