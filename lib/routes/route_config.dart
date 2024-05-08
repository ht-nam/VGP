import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/routes/route_const.dart';
import 'package:vgp/views/auth/authentication_screen.dart';
import 'package:vgp/views/home/home_screen.dart';
import 'package:vgp/views/scanner/scanner_screen.dart';

class MyRouter {
  MyRouter({required this.initialLocation});

  final String initialLocation;
  late GoRouter router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
          name: RouteConstants.homeRouteName,
          path: '/',
          builder: (context, state) => const HomeScreen(),
          redirect: isAuthenticated),
      GoRoute(
        name: RouteConstants.loginRouteName,
        path: '/${RouteConstants.loginRouteName}',
        builder: (context, state) =>
            AuthenticationScreen(isForgotPassword: false),
      ),
      GoRoute(
        name: RouteConstants.forgotPasswordRouteName,
        path: '/${RouteConstants.forgotPasswordRouteName}',
        builder: (context, state) =>
            AuthenticationScreen(isForgotPassword: true),
      ),
      GoRoute(
        name: RouteConstants.scannerRouteName,
        path: '/${RouteConstants.scannerRouteName}',
        builder: (context, state) => const ScannerScreen(),
      ),
      // GoRoute(
      //   name: RouteConstants.processDetailRouteName,
      //   path: '/${RouteConstants.processDetailRouteName}',
      //   builder: (context, state) {
      //     final Map? data = state.extra as Map?;
      //     final bool readOnly = (data?['readOnly'] ?? false) as bool;
      //     final String partName = (data?['partName'] ?? '') as String;
      //     return ProcessDetailScreen(readOnly: readOnly, partName: partName);
      //   },
      // ),
    ],
  );

  FutureOr<String?> isAuthenticated(
      BuildContext context, GoRouterState route) async {
    // (await SharedPre.instance).remove(SharedPrefsConstants.ACCESS_TOKEN_KEY);
    if ((await SharedPre.instance)
            .getString(SharedPrefsConstants.ACCESS_TOKEN_KEY) ==
        null) {
      return '/login';
    }
    return null;
  }
}
