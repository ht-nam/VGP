import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_widget.dart';
import 'package:vgp/views/auth/widgets/forgot_password_form.dart';
import 'package:vgp/views/auth/widgets/login_form.dart';

class AuthenticationScreen extends BaseConsumerWidget {
  final bool isForgotPassword;
  AuthenticationScreen({key, required this.isForgotPassword}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authContainerWidth = MediaQuery.of(context).size.width *
        (MediaQuery.of(context).size.width < 600 ? 1 : 0.5);
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            width: authContainerWidth,
            child: !isForgotPassword
                ? const AuthScreen()
                : const ForgotPasswordForm(),
          ),
        ),
      ),
    );
  }
}
