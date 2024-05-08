import 'package:flutter/material.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.textEditingController,
    this.hint,
    this.label,
    this.textStyle,
    this.validator,
  }) : super(key: key);

  final String? hint;
  final String? label;
  final TextStyle? textStyle;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(label!, style: textStyle))
            : const SizedBox(),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            validator: validator,
            cursorColor: AppTheme.primaryColor,
            controller: textEditingController,
            obscureText: true,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: textStyle ?? const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              label: hint != null ? Text(hint!) : null,
              hintText: hint,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
              focusedBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
