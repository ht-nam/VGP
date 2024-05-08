import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/models/app_setting.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_state.dart';
import 'package:vgp/resources/widgets/rounded_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vgp/routes/route_const.dart';
import 'package:vgp/viewmodels/app_setting_view_model.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState createState() => _LoginFormState();
}

class _LoginFormState extends BaseConsumerState<ForgotPasswordForm> {
  late AsyncValue<AppSetting> _appSetting;
  final TextEditingController _email = TextEditingController();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appSetting = ref.watch(appSettingViewModelProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: _appSetting.value?.largeTextSize),
          ),
          const SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            AppLocalizations.of(context)!.forgotPasswordDetail,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: _appSetting.value?.mediumTextSize),
          ),
          const SizedBox(height: 20),
          RoundedInput(
            textEditingController: _email,
            label: AppLocalizations.of(context)!.emailAddress,
            textInputType: TextInputType.emailAddress,
            textStyle: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: _appSetting.value?.smallTextSize),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _forgotPassword,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: Text(
              AppLocalizations.of(context)!.send,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.white,
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
              onPressed: () => goName(context, RouteConstants.loginRouteName),
              child: Text(
                AppLocalizations.of(context)!.havePassword,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: _appSetting.value?.mediumTextSize,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    // setState(() {});
  }

  void _forgotPassword() async {
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email.text)) {
      showErrorToast("Please enter a valid email");
    } else {
      showSuccessToast("An email has been sent");
    }
  }
}
