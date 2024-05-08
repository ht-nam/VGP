import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vgp/resources/widgets/base_screen/base_consumer_widget.dart';

class CustomTable extends BaseConsumerWidget {
  CustomTable(
      {super.key,
      required this.headers,
      required this.dataList,
      required this.rules,
      required this.colWidthRatioList,
      this.maxWidth = 1000,
      this.maxHeight = 1000,
      this.onRowClick});

  final List<String> headers;
  final List<dynamic> dataList;
  final List<double> colWidthRatioList;
  final List rules;
  final double maxWidth;
  final double maxHeight;
  final void Function()? onRowClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (headers.length != colWidthRatioList.length) {
      return Container();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: maxWidth,
        height: maxHeight,
        child: Column(
          children: [_header(), Expanded(child: _body())],
        ),
      ),
    );
  }

  Widget _header() {
    final List<Widget> headerChildren = [];
    for (int i = 0; i < headers.length; i++) {
      headerChildren.add(SizedBox(
        width: maxWidth * colWidthRatioList[i],
        child: Text(
          headers[i],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: headerChildren,
      ),
    );
  }

  Widget _body() {
    if (dataList.isEmpty) {
      return Container();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        final List<Widget> bodyChildren = [];

        for (int i = 0; i < headers.length; i++) {
          bodyChildren.add(Container(
            alignment: Alignment.centerLeft,
            width: maxWidth * colWidthRatioList[i],
            child: rules[i](i == 0 ? index + 1 : dataList[index]),
          ));
        }
        return InkWell(
          onTap: onRowClick,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
            ),
            child: Row(
              children: bodyChildren,
            ),
          ),
        );
      },
    );
  }
}
