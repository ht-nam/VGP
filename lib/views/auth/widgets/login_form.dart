import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/models/app_setting.dart';
import 'package:vgp/resources/constants/constants.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/utils/data_sources/dio_client.dart';
import 'package:vgp/resources/utils/data_sources/local.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_state.dart';
import 'package:vgp/resources/widgets/rounded_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/routes/route_const.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';
import 'package:vgp/viewmodels/auth_view_model.dart';
import '../../../resources/widgets/rounded_password_input.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState createState() => _LoginFormState();
}

class _LoginFormState extends BaseConsumerState<AuthScreen> {
  // viewmodels
  late AsyncValue<AppSetting> _appSetting;
  late AuthViewModel _authViewModel;
  // attributes
  final _formKey = GlobalKey<FormState>();
  late bool _isRememberPassword;
  final TextEditingController _id = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    _authViewModel = AuthViewModel();
    _isRememberPassword = false;
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appSetting = ref.watch(appSettingViewModelProvider);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset('assets/images/app_name_icon.png', height: 100),
            const SizedBox(height: 20),
            RoundedInput(
              textEditingController: _id,
              label: AppLocalizations.of(context)!.email,
              textInputType: TextInputType.emailAddress,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: _appSetting.value?.mediumTextSize),
              validator: (value) => value != null && value.isNotEmpty
                  ? null
                  : AppLocalizations.of(context)!.usernameValidation,
            ),
            RoundedPasswordInput(
              textEditingController: _password,
              label: AppLocalizations.of(context)!.password,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: _appSetting.value?.mediumTextSize),
              validator: (value) => value != null && value.length >= 8
                  ? null
                  : AppLocalizations.of(context)!.passwordValidation,
            ),
            CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                checkColor: AppTheme.white,
                activeColor: AppTheme.primaryColor,
                title: Text(AppLocalizations.of(context)!.rememberPassword,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: _appSetting.value?.mediumTextSize)),
                value: _isRememberPassword,
                onChanged: _checkboxOnChange),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: Text(
                AppLocalizations.of(context)!.login,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: _appSetting.value?.mediumTextSize,
                    ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    goName(context, RouteConstants.forgotPasswordRouteName),
                child: Text(
                  AppLocalizations.of(context)!.forgotPassword,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: _appSetting.value?.mediumTextSize,
                      ),
                ),
              ),
            ),
            // changeSizeBtnTest(),
          ],
        ),
      ),
    );
  }

  Widget _changeSizeBtnTest() {
    return ElevatedButton(
      onPressed: () async {
        ref
            .read(appSettingViewModelProvider.notifier)
            .changeFontSize(_appSetting.value?.fontSize == 16 ? 14 : 16);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: Text(
        "Change font size",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.w600,
            fontSize: _appSetting.value?.fontSize),
      ),
    );
  }

  Future<void> _fetchData() async {
    _isRememberPassword = (await SharedPre.instance)
            .getBool(SharedPrefsConstants.REMEMBER_PASSWORD_KEY) ??
        false;
    setState(() {});
  }

  void _checkboxOnChange(bool? value) async {
    (await SharedPre.instance)
        .setBool(SharedPrefsConstants.REMEMBER_PASSWORD_KEY, value ?? false);
    setState(() {
      _isRememberPassword = value ?? false;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      showLoading(context, show: true);
      final bool isLoggedIn = await _authViewModel.login(
          username: _id.text, password: _password.text);
      showLoading(context, show: false);
      if (isLoggedIn) {
        goName(context, RouteConstants.homeRouteName);
      }
    }
  }
}
