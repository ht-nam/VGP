import 'package:flutter/material.dart';
import 'package:vgp/resources/utils/app/app_theme.dart';

class CustomDropdownTextField extends StatelessWidget {
  const CustomDropdownTextField(
      {Key? key,
      required this.label,
      required this.data,
      required this.keyField,
      required this.valueField,
      this.onChange,
      this.textStyle,
      this.currentSelectedValue})
      : super(key: key);

  final String label;
  final List<dynamic> data;
  final String keyField;
  final String valueField;
  final Function? onChange;
  final TextStyle? textStyle;
  final dynamic currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu(
          requestFocusOnTap: true,
          enableFilter: true,
          menuHeight: 300,
          width: constraints.maxWidth,
          label: Text(label, style: textStyle ?? const TextStyle(fontSize: 20)),
          textStyle: textStyle ?? const TextStyle(fontSize: 20),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            hoverColor: AppTheme.primaryColor,
            suffixIconColor: AppTheme.primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor, width: 2),
            ),
          ),
          onSelected: (dynamic newValue) {
            if (onChange != null && newValue != null) {
              onChange!(newValue);
            }
            FocusManager.instance.primaryFocus?.unfocus();
          },
          initialSelection: currentSelectedValue,
          dropdownMenuEntries: data.map((dynamic value) {
            return DropdownMenuEntry<dynamic>(
              value: value?[keyField],
              label: '${value[valueField]}',
              style: MenuItemButton.styleFrom(),
            );
          }).toList(),
        );
      },
    );
  }
}
