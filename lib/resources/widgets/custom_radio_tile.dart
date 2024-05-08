import 'package:flutter/material.dart';

class CustomRadioTile<T> extends StatelessWidget {
  const CustomRadioTile(
      {super.key,
      required this.value,
      required this.groupValue,
      this.onChanged,
      required this.title,
      this.activeColor,
      this.padding = const EdgeInsets.all(16),
      this.spacing = 10});

  final T value;
  final T groupValue;
  final Widget title;
  final Function(T?)? onChanged;
  final Color? activeColor;
  final double spacing;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          if (onChanged != null && groupValue != value) {
            onChanged!(value);
          }
        },
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Radio(
            value: value,
            groupValue: groupValue,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            activeColor: activeColor,
            onChanged: onChanged,
          ),
          SizedBox(width: spacing),
          title,
        ]),
      ),
    );
  }
}
