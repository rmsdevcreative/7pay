import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/text/small_text.dart';
import 'package:toastification/toastification.dart';

import '../../../core/utils/util_exporter.dart';

class CustomSnackBar {
  static error({
    required List<String> errorList,
    int duration = 5,
    bool dismissAll = true,
  }) {
    String message = '';
    if (errorList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in errorList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
        // message = AppConverter.removeQuotationAndSpecialCharacterFromString(message);
        if (dismissAll) {
          toastification.dismissAll();
        }

        toastification.show(
          context: Get.context,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: Text(
            tempMessage,
            maxLines: 10,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: MyColor.white,
            ),
          ),
          alignment: Alignment.topCenter,
          foregroundColor: MyColor.white,
          primaryColor: MyColor.error,
          showProgressBar: false,
          autoCloseDuration: Duration(seconds: duration),
          borderRadius: BorderRadius.circular(Dimensions.largeRadius),
          applyBlurEffect: false,
        );
      }
    }
  }

  static success({
    required List<String> successList,
    int duration = 5,
    bool dismissAll = false,
  }) {
    String message = '';
    if (successList.isEmpty) {
      message = MyStrings.somethingWentWrong.tr;
    } else {
      for (var element in successList) {
        String tempMessage = element.tr;
        message = message.isEmpty ? tempMessage : "$message\n$tempMessage";
      }
    }
    message = AppConverter.removeQuotationAndSpecialCharacterFromString(
      message,
    );
    if (dismissAll) {
      toastification.dismissAll();
    }
    toastification.show(
      context: Get.context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: Text(
        message,
        maxLines: 10,
        style: Get.theme.textTheme.bodyMedium?.copyWith(color: MyColor.white),
      ),
      alignment: Alignment.topCenter,
      foregroundColor: MyColor.white,
      primaryColor: MyColor.success,
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: duration),
      borderRadius: BorderRadius.circular(Dimensions.largeRadius),
      applyBlurEffect: false,
    );
  }

  static showToast({
    required String message,
    int duration = 2,
    bool dismissAll = false,
  }) {
    toastification.showCustom(
      context: Get.context, // optional if you use ToastificationWrapper
      autoCloseDuration: const Duration(seconds: 2),
      alignment: Alignment.bottomCenter,
      builder: (BuildContext context, ToastificationItem holder) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusProMax),
              color: MyColor.success,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.space10,
              vertical: Dimensions.space8,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.space10,
              vertical: Dimensions.space10,
            ),
            child: SmallText(
              text: MyStrings.copiedToClipBoard,
              textStyle: MyTextStyle.sectionSubTitle1.copyWith(
                color: MyColor.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
