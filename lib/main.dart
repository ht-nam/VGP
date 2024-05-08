import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/routes/route_config.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  MyRouter myRouter = MyRouter(initialLocation: '/login');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      supportedLocales: L10n.all,
      locale: const Locale(AppConstants.APP_LANGUAGE),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: myRouter.router,
      // home: const HomePage(),
    );
  }
}
