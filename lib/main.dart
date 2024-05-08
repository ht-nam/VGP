import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/routes/route_config.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale(AppConstants.APP_LANGUAGE);
  MyRouter myRouter = MyRouter(initialLocation: '/login');

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      supportedLocales: L10n.all,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: myRouter.router,
      // home: const HomePage(),
    );
  }

  void fetchData() async {
    final language = (await SharedPre.instance).getString(SharedPrefsConstants.LANGUAGE_KEY) ?? AppConstants.APP_LANGUAGE;
    setState(() {
      _locale = Locale(language);
    });
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }
}
