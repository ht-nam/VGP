import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/resources/utils/helpers/helper_mixin.dart';

class BaseConsumerWidget extends ConsumerWidget with HelperMixin {
  BaseConsumerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw UnimplementedError();
  }
}
