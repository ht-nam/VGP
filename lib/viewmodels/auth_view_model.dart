import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/data_sources/dio_client.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/resources/utils/helpers/helper_mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthViewModel with HelperMixin {
  Future<bool> login({String? username, String? password}) async {
    (await SharedPre.instance)
        .setString(SharedPrefsConstants.ACCESS_TOKEN_KEY, 'A');
    return true;
  }

  Future<bool> loginA({String? username, String? password}) async {
    //temp
    final multiLang = await AppLocalizations.delegate
        .load(const Locale(AppConstants.APP_LANGUAGE));
    try {
      final body = {'login_id': username ?? '', 'password': password ?? ''};
      final response = await DioClient()
          .postLogin("${ApiConstants.BASE_URL}/login", data: body);
      if (response.statusCode == 200 && response.data?['data'] != null) {
        (await SharedPre.instance).setString(
            SharedPrefsConstants.ACCESS_TOKEN_KEY,
            response.data?['data']?['token']);
        (await SharedPre.instance).setString(SharedPrefsConstants.USER_PROFILE,
            jsonEncode(response.data?['data']));
        showSuccessToast(multiLang.loginSuccessful);
        return true; // need redirect after successful login
      } else {
        showErrorToast(multiLang.loginFailed);
      }
    } catch (e) {
      showErrorToast(multiLang.unexpectedError);
    }
    return false;
  }

  Future<void> logout() async {
    (await SharedPre.instance).remove(SharedPrefsConstants.ACCESS_TOKEN_KEY);
    // need redirect after logout
  }

  Future<bool> changePassword({String? password, String? newPassword}) async {
    final multiLang = await AppLocalizations.delegate
        .load(const Locale(AppConstants.APP_LANGUAGE));
    try {
      final body = {
        'old_password': password ?? '',
        'password': newPassword ?? '',
        'password_confirmation': newPassword ?? ''
      };
      final response = await DioClient()
          .post("${ApiConstants.BASE_URL}/change_password", data: body);
      if (response.statusCode == 200) {
        showSuccessToast(multiLang.changePasswordSuccessful);
        return true;
      } else {
        showErrorToast(multiLang.changePasswordFailed);
      }
    } catch (e) {
      showErrorToast(multiLang.unexpectedError);
    }
    return false;
  }
}
