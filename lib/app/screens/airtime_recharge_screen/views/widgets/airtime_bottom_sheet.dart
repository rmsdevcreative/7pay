import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/chip/custom_chip.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/airtime_recharge_screen/controller/airtime_recharge_controller.dart';
import 'package:ovopay/core/data/models/modules/airtime_recharge/airtime_recharge_operators_response_model.dart';
import 'package:ovopay/core/data/models/modules/airtime_recharge/airtime_recharge_response_model.dart';

import '../../../../../core/utils/util_exporter.dart';

class AirTimeBottomSheet {
  static void otpBottomSheet(
    BuildContext context, {
    required void Function() onSuccessCallback,
  }) {
    CustomBottomSheetPlus(
      child: GetBuilder<AirTimeRechargeController>(
        builder: (controller) {
          return Container(
            // padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.getWhiteColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetBar(),
                // spaceDown(Dimensions.space24),
                if (controller.otpType.isNotEmpty) ...[
                  spaceDown(Dimensions.space16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: MyStrings.verificationType,
                        textStyle: MyTextStyle.headerH3.copyWith(
                          color: MyColor.getHeaderTextColor(),
                        ),
                      ),
                      spaceDown(Dimensions.space16),
                      Row(
                        children: controller.otpType.map((value) {
                          return CustomAppChip(
                            backgroundColor: MyColor.getWhiteColor(),
                            isSelected: value == controller.selectedOtpType,
                            text: controller.getOtpType(value),
                            onTap: () {
                              controller.selectAnOtpType(value);
                            },
                          );
                        }).toList(),
                      ),
                      spaceDown(Dimensions.space16),
                    ],
                  ),
                ],
                spaceDown(Dimensions.space15),
                AppMainSubmitButton(
                  isLoading: controller.isSubmitLoading,
                  isActive: controller.amountController.text.trim().isNotEmpty,
                  text: MyStrings.continueText,
                  onTap: () {
                    controller.submitThisProcess(
                      onSuccessCallback: (value) {
                        onSuccessCallback();
                      },
                      onVerifyOtpCallback: (value) async {
                        Navigator.pop(context);
                        await AppDialogs.verifyOtpPopUpWidget(
                          context,
                          onSuccess: (value) async {
                            Navigator.pop(context);
                            onSuccessCallback();
                          },
                          title: '',
                          actionRemark: controller.actionRemark,
                          otpType: controller.selectedOtpType,
                        );
                        return;
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    ).show(context);
  }

  static void countryBottomSheet(
    BuildContext context, {
    required void Function(CountryList data) onSelectedData,
    required AirTimeRechargeController controller,
  }) {
    CustomBottomSheetPlus(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.getWhiteColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetBar(),
                spaceDown(Dimensions.space24),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.countryDataList.length,
                    itemBuilder: (context, index) {
                      var countryItem = controller.countryDataList[index];

                      return GestureDetector(
                        onTap: () {
                          onSelectedData(countryItem);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.space15),
                          // margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: MyColor.transparentColor,
                            border: Border(
                              bottom: BorderSide(
                                color: MyColor.getBorderColor(),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: Dimensions.space10,
                                ),
                                child: MyNetworkImageWidget(
                                  isSvg: true,
                                  imageUrl: countryItem.flagUrl ?? "",
                                  height: null,
                                  width: Dimensions.space45.w,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: Dimensions.space10,
                                ),
                                child: Text(
                                  countryItem.callingCodes?.first ?? "",
                                  style: MyTextStyle.sectionTitle3.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${countryItem.name}',
                                  style: MyTextStyle.sectionTitle3.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).show(context);
  }

  static void operatorsBottomSheet(
    BuildContext context, {
    required void Function(OperatorData data) onSelectedData,
    required AirTimeRechargeController controller,
  }) {
    CustomBottomSheetPlus(
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * .8,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: MyColor.getWhiteColor(),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const BottomSheetBar(),
                spaceDown(Dimensions.space24),
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.operatorDataList.length,
                    itemBuilder: (context, index) {
                      var operatorItem = controller.operatorDataList[index];

                      return GestureDetector(
                        onTap: () {
                          onSelectedData(operatorItem);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.space10,
                            vertical: Dimensions.space15,
                          ),
                          // margin: const EdgeInsets.all(5),v
                          decoration: BoxDecoration(
                            color: MyColor.transparentColor,
                            border: Border(
                              bottom: BorderSide(
                                color: MyColor.getBorderColor(),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: Dimensions.space10,
                                ),
                                child: MyNetworkImageWidget(
                                  imageUrl: operatorItem.logoUrls?.isNotEmpty == true ? operatorItem.logoUrls!.first : "",
                                  height: Dimensions.space60.w,
                                  width: Dimensions.space60.w,
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${operatorItem.name}',
                                  style: MyTextStyle.sectionTitle3.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).show(context);
  }
}
