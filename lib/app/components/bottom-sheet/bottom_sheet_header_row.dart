import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/bottom_sheet_close_button.dart';
import 'package:ovopay/app/components/text/bottom_sheet_header_text.dart';
import 'package:ovopay/core/utils/dimensions.dart';
import 'package:ovopay/core/utils/my_color.dart';

class BottomSheetHeaderRow extends StatelessWidget {
  final String header;
  final double bottomSpace;
  const BottomSheetHeaderRow({
    super.key,
    this.header = '',
    this.bottomSpace = Dimensions.space10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: MyColor.getBorderColor(),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: BottomSheetHeaderText(text: header.tr)),
            const BottomSheetCloseButton(),
          ],
        ),
        SizedBox(height: bottomSpace),
      ],
    );
  }
}
