import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/loading_view.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';

mixin HelperMixin {
  LoadingView? loadingView;

  double getBodyHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        AppConstants.APP_BAR_HEIGHT;
  }

  void showLoading(BuildContext context, {required bool show, Color? color}) {
    loadingView ??= LoadingView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (show) {
        loadingView!.show(context, color: color);
      } else {
        loadingView!.hide();
      }
    });
  }

  void showLoadingWithDuration(BuildContext context, Duration duration) {
    loadingView ??= LoadingView();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingView!.show(context);
      Future.delayed(duration, () {
        loadingView!.hide();
      });
    });
  }

  void pushedName(BuildContext context, String routeName, {Object? extra}) {
    showLoading(context, show: true);
    context.pushNamed(routeName, extra: extra);
    showLoading(context, show: false);
  }

  void goName(BuildContext context, String routeName) {
    showLoading(context, show: true);
    context.goNamed(routeName);
    showLoading(context, show: false);
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  Widget loadingCenter(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void dismissLoading(BuildContext context, String? isback) {
    if (loadingView != null) {
      loadingView!.hide();
    }
    if (isback != null) {
      backToScreen(context);
    }
  }

  backToScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<void> modalBottomSheetMenu(
      {required BuildContext context,
      required Widget child,
      bool isDrag = true}) {
    return showModalBottomSheet(
        context: context,
        enableDrag: isDrag,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        builder: (builder) {
          return child;
        });
  }

  void showSuccessToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.deepOrangeAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showAlertDialog(BuildContext context, WidgetRef ref, String content) {
    final appSetting = ref.watch(appSettingViewModelProvider);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          content,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontSize: appSetting.value?.smallTextSize),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              'OK',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: appSetting.value?.smallTextSize),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  Future<void> showCenterPopUpDialog(
      BuildContext context, WidgetRef ref, Widget dialogModal) async {
    await showDialog(
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: dialogModal,
        );
      },
    );
  }

  String japaneseDateConvert(String? date) {
    // return 'yyyy年MM月dd日'
    try {
      return DateFormat("yyyy年MM月dd日").format(DateTime.parse(date!));
    } catch (e) {
      return '';
    }
  }
}
