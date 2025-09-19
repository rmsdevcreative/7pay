import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopay/app/components/chip/custom_chip.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/request_money_screen/controller/request_money_controller.dart';
import 'package:ovopay/core/data/services/service_exporter.dart';

import '../../../../../core/utils/util_exporter.dart';

class RequestMoneyAmountPage extends StatefulWidget {
  const RequestMoneyAmountPage({
    super.key,
    required this.context,
    required this.onSuccessCallback,
  });

  final VoidCallback onSuccessCallback;
  final BuildContext context;

  @override
  State<RequestMoneyAmountPage> createState() => _RequestMoneyAmountPageState();
}

class _RequestMoneyAmountPageState extends State<RequestMoneyAmountPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestMoneyController>(
      builder: (requestMoneyController) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContactListTileCard(
                        leading: MyNetworkImageWidget(
                          width: Dimensions.space40.w,
                          height: Dimensions.space40.w,
                          isProfile: true,
                          imageUrl: '${requestMoneyController.existUserModel?.getUserImageUrl()}',
                          imageAlt: requestMoneyController.existUserModel?.getFullName() ?? "",
                        ),
                        padding: EdgeInsets.zero,
                        imagePath: requestMoneyController.existUserModel?.getUserImageUrl(),
                        title: requestMoneyController.existUserModel?.getFullName(),
                        subtitle: "+${requestMoneyController.existUserModel?.getUserMobileNo(withCountryCode: true)}",
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
                spaceDown(Dimensions.space16),
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(
                        text: MyStrings.enterAmount.tr,
                        textStyle: MyTextStyle.headerH3.copyWith(
                          color: MyColor.getHeaderTextColor(),
                        ),
                      ),
                      spaceDown(Dimensions.space24),
                      RoundedTextField(
                        controller: requestMoneyController.amountController,
                        showLabelText: false,
                        labelText: MyStrings.enterAmount.tr,
                        hintText: '',
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textStyle: MyTextStyle.headerH3.copyWith(
                          color: MyColor.getHeaderTextColor(),
                        ),
                        focusBorderColor: MyColor.getPrimaryColor(),
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]'),
                          ), // Allows digits and a decimal point
                          FilteringTextInputFormatter.deny(
                            RegExp(r'(\.\d{30,})'),
                          ), // Limits decimal places (optional, adjust as needed)
                        ],
                        onChanged: (value) {
                          requestMoneyController.onChangeAmountControllerText(
                            value,
                          );
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return MyStrings.kAmountNumberError.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      // //TODO -REQUEST LIMIT
                      // spaceDown(Dimensions.space8),
                      // Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: "${MyStrings.requestLimit.tr}: ",
                      //         style: MyTextStyle.sectionBodyTextStyle.copyWith(color: MyColor.getBodyTextColor()),
                      //       ),
                      //       TextSpan(
                      //         text: MyUtils.getUserAmount("000"),
                      //         style: MyTextStyle.sectionBodyBoldTextStyle.copyWith(color: MyColor.getPrimaryColor()),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      spaceDown(Dimensions.space24),
                      SingleChildScrollView(
                        clipBehavior: Clip.hardEdge,
                        scrollDirection: Axis.horizontal, // Allows horizontal scrolling
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: SharedPreferenceService.getQuickMoneyList().map((
                            value,
                          ) {
                            return CustomAppChip(
                              isSelected: value == requestMoneyController.getAmount ? true : false,
                              text: value,
                              onTap: () {
                                requestMoneyController.onChangeAmountControllerText(value);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (requestMoneyController.otpType.isNotEmpty) ...[
                  spaceDown(Dimensions.space16),
                  CustomAppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderText(
                          text: MyStrings.verificationType,
                          textStyle: MyTextStyle.sectionTitle2.copyWith(
                            color: MyColor.getHeaderTextColor(),
                          ),
                        ),
                        spaceDown(Dimensions.space8),
                        Row(
                          children: requestMoneyController.otpType.map((value) {
                            return CustomAppChip(
                              backgroundColor: MyColor.getWhiteColor(),
                              isSelected: value == requestMoneyController.selectedOtpType,
                              text: requestMoneyController.getOtpType(
                                value,
                              ),
                              onTap: () => requestMoneyController.selectAnOtpType(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
                spaceDown(Dimensions.space15),
                AppMainSubmitButton(
                  isLoading: requestMoneyController.isSubmitLoading,
                  isActive: requestMoneyController.amountController.text.trim().isNotEmpty,
                  text: MyStrings.next,
                  onTap: () {
                    if (requestMoneyController.selectedOtpType == "") {
                      if (requestMoneyController.otpType.isNotEmpty) {
                        CustomSnackBar.error(
                          errorList: [MyStrings.pleaseSelectAnOtpType.tr],
                        );
                        return;
                      }
                    }
                    if (formKey.currentState?.validate() ?? false) {
                      requestMoneyController.submitThisProcess(
                        onSuccessCallback: (value) {
                          widget.onSuccessCallback();
                        },
                        onVerifyOtpCallback: (value) async {
                          await AppDialogs.verifyOtpPopUpWidget(
                            context,
                            onSuccess: (value) async {
                              Navigator.pop(context);
                              widget.onSuccessCallback();
                            },
                            title: '',
                            actionRemark: requestMoneyController.actionRemark,
                            otpType: requestMoneyController.selectedOtpType,
                          );
                          return;
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
