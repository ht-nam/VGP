import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput(
      {Key? key,
      this.icon,
      required this.textEditingController,
      this.hint,
      this.label,
      this.textStyle,
      this.textInputType = TextInputType.text,
      this.imageAsset,
      this.onTap,
      this.maxLines = 1,
      this.readOnly,
      this.marginContainer,
      this.colorContainer,
      this.maxLength,
      this.onChanged,
      this.validator,
      this.isInlineLabel = false})
      : super(key: key);

  final IconData? icon;
  final Widget? imageAsset;
  final String? hint;
  final String? label;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final Function()? onTap;
  final bool? readOnly;
  final EdgeInsetsGeometry? marginContainer;
  final int? maxLength;
  final Color? colorContainer;
  final int? maxLines;
  final TextStyle? textStyle;
  final bool isInlineLabel;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null && !isInlineLabel
            ? Container(
                margin: marginContainer ??
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  label!,
                  style: textStyle,
                ),
              )
            : const SizedBox(),
        Container(
          margin: marginContainer ?? const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            onChanged: onChanged,
            validator: validator,
            maxLength: maxLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                  textInputType.toString().contains("phone") ? 11 : 255)
            ],
            maxLines: maxLines,
            readOnly: readOnly ?? false,
            cursorColor: AppTheme.primaryColor,
            controller: textEditingController,
            keyboardType: textInputType,
            onTap: onTap,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            style: textStyle ?? const TextStyle(fontSize: 20),
            decoration: InputDecoration(
                icon: icon != null
                    ? Icon(icon, color: AppTheme.blueGreyDark)
                    : null,
                hintText: hint,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                counterText: "",
                labelText: isInlineLabel ? label : null,
                labelStyle: textStyle,
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          ),
        ),
      ],
    );
  }
}
