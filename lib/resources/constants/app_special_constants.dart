import 'package:flutter/cupertino.dart';
import 'package:vgp/models/app/app_input.dart';

// Icon data
// https://api.flutter.dev/flutter/material/Icons-class.html

class AppInputConstants {
  static final List<AppInput> jokeInputs = [
    AppInput(
      hint: "Input type",
      icon: const IconData(0xf07d0, fontFamily: 'MaterialIcons'),
      slug: 'type',
    ),
    AppInput(
      hint: "Input setup",
      icon: const IconData(0xe57f, fontFamily: 'MaterialIcons'),
      slug: 'setup',
    ),
    AppInput(
      hint: "Input punchline",
      icon: const IconData(0xe59d,
          fontFamily: 'MaterialIcons', matchTextDirection: true),
      slug: 'punchline',
    ),
  ];
}

class HistoryTableConstants {
  static const List<double> colWidthRatioList = [
    0.1,
    0.2,
    0.1,
    0.18,
    0.18,
    0.14,
    0.1
  ]; // total must be 1
  static const List<String> headers = [
    "#",
    "部品",
    "案件",
    "登録開始日付",
    "最後更新日",
    "ステータス",
    "操作"
  ];
}

class ProcessDetailTableConstants {
  static const List<double> colWidthRatioList = [
    0.05,
    0.2,
    0.15,
    0.1,
    0.15,
    0.15,
    0.1,
    0.1
  ]; // total must be 1
  static const List<String> headers = [
    "#",
    "データ名",
    "値",
    "単位",
    "入力方法",
    "更新日時",
    "作業者",
    "リセット"
  ];

  static const List<double> colWidthRatioListReadOnly = [
    0.1,
    0.2,
    0.2,
    0.1,
    0.2,
    0.2
  ]; // total must be 1
  static const List<String> headersReadOnly = [
    "#",
    "データ名",
    "値",
    "単位",
    "更新日時",
    "作業者"
  ];
}
