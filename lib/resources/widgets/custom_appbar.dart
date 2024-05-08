import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_widget.dart';
import 'package:vgp/routes/route_const.dart';

class CustomAppBar extends BaseConsumerWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key, required this.hasLeading, required this.hasTrailing});

  final bool hasLeading;
  final bool hasTrailing;

  @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  Size get preferredSize => const Size.fromHeight(AppConstants.APP_BAR_HEIGHT);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final a = GoRouter.of(context).routerDelegate.currentConfiguration.matches;
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      // title: Image.asset('assets/images/app_name_icon_a.png',
      //     height: AppConstants.APP_BAR_HEIGHT * 2 / 3),
      centerTitle: true,
      iconTheme: const IconThemeData(
          color: Colors.white, size: AppConstants.APP_BAR_HEIGHT * 4 / 5),
      leadingWidth: hasLeading ? 100 : null,
      leading: _appBarLeading(context),
      actions: _appBarTrailing(context),
    );
  }

  Widget? _appBarLeading(BuildContext context) {
    if (!hasLeading) return null;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back_ios_rounded),
          ),
        ),
        GoRouter.of(context)
                    .routerDelegate
                    .currentConfiguration
                    .matches
                    .length >
                2
            ? InkWell(
                onTap: () => Navigator.popUntil(
                    context, ModalRoute.withName(RouteConstants.homeRouteName)),
                child: const Icon(Icons.home),
              )
            : const SizedBox(),
      ],
    );
  }

  List<Widget>? _appBarTrailing(BuildContext context) {
    if (!hasTrailing) return null;

    return [
      InkWell(
        onTap: () => pushedName(context, RouteConstants.tempRouteName),
        child: const Icon(IconData(0xf08ae, fontFamily: 'MaterialIcons')),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InkWell(
          onTap: () => pushedName(context, RouteConstants.tempRouteName),
          child: const Icon(
            IconData(0xe0a5,
                fontFamily: 'MaterialIcons', matchTextDirection: true),
          ),
        ),
      ),
    ];
  }
}
