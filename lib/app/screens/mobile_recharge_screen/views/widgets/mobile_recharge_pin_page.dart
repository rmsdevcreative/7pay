import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/amount_details_card.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/custom_contact_list_tile_card.dart';
import 'package:ovopay/app/components/column_widget/card_column.dart';
import 'package:ovopay/app/components/dialog/app_dialog.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/screens/mobile_recharge_screen/controller/mobile_recharge_controller.dart';

import '../../../../../core/data/services/service_exporter.dart';
import '../../../../../core/utils/util_exporter.dart';

class MobileRechargePinVerificationPage extends StatelessWidget {
  const MobileRechargePinVerificationPage({super.key, required this.context});

  final BuildContext context;

  // Reusable Contact List Tile
  Widget _buildContactTile(
    MobileRechargeController controller, {
    bool showBorder = true,
    EdgeInsetsGeometry? padding,
  }) {
    return CustomContactListTileCard(
      leading: MyNetworkImageWidget(
        width: Dimensions.space40.w,
        height: Dimensions.space40.w,
        isProfile: true,
        imageUrl: "",
        imageAlt: controller.getPhoneNumber,
      ),
      padding: padding ?? EdgeInsets.zero,
      imagePath: controller.selectedOperator?.getImageUrl(),
      title: controller.getPhoneNumber,
      subtitle: "${controller.selectedOperator?.name}",
      trailing: MyNetworkImageWidget(
        imageUrl: "${controller.selectedOperator?.getImageUrl()}",
        width: Dimensions.space63.w,
        boxFit: BoxFit.contain,
        height: null,
      ),
      showBorder: showBorder,
    );
  }

  // Reusable Amount Details Card
  Widget _buildAmountDetailsCard(MobileRechargeController controller) {
    return AmountDetailsCard(
      amount: MyUtils.getUserAmount(controller.mainAmount.toString()),
      charge: '+${MyUtils.getUserAmount(controller.totalCharge.toString())}',
      total: MyUtils.getUserAmount(controller.payableAmountText.toString()),
    );
  }

  // Reusable Confirm Dialog
  Future<void> _showConfirmDialog(MobileRechargeController controller) async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (controller.pinController.text.toString().length < SharedPreferenceService.getMaxPinNumberDigit()) {
      CustomSnackBar.error(
        errorList: [
          MyStrings.kPinMaxNumberError.tr.rKv({
            "digit": "${SharedPreferenceService.getMaxPinNumberDigit()}",
          }).tr,
        ],
      );
      return;
    }
    await AppDialogs.confirmDialog(
      context,
      title: MyStrings.mobileRecharge,
      userDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildContactTile(controller, showBorder: false),
      ),
      cashDetailsWidget: CustomAppCard(
        radius: Dimensions.largeRadius.r,
        child: _buildAmountDetailsCard(controller),
      ),
      onFinish: () async {
        await controller.pinVerificationProcess(
          onSuccessCallback: (value) async {
            // Handle the completed progress here
            Navigator.pop(context);
            await AppDialogs.successDialog(
              context,
              title: value.message?.first ?? "",
              userDetailsWidget: CustomAppCard(
                radius: Dimensions.largeRadius.r,
                child: _buildContactTile(controller, showBorder: false),
              ),
              cashDetailsWidget: CustomAppCard(
                radius: Dimensions.largeRadius.r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAmountDetailsCard(controller),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: MyColor.getBorderColor(),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    CardColumn(
                      headerTextStyle: MyTextStyle.caption1Style.copyWith(
                        color: MyColor.getBodyTextColor(),
                      ),
                      header: MyStrings.transactionId.tr,
                      isCopyable: true,
                      body: value.data?.transaction?.trx ?? "",
                      space: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ],
                ),
              ),
            );
            return;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MobileRechargeController>(
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactTile(
                      controller,
                      padding: EdgeInsetsDirectional.only(
                        bottom: Dimensions.space10,
                      ),
                    ),
                    spaceDown(Dimensions.space16),
                    _buildAmountDetailsCard(controller),
                  ],
                ),
              ),
              spaceDown(Dimensions.space16),
              RoundedTextField(
                showLabelText: false,
                controller: controller.pinController,
                labelText: MyStrings.pin,
                hintText: MyStrings.enterYourPinCode,
                isPassword: true,
                forceShowSuffixDesign: true,
                fillColor: MyColor.getWhiteColor(),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                    SharedPreferenceService.getMaxPinNumberDigit(),
                  ),
                ],
                prefixIcon: Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: Dimensions.space15,
                    end: Dimensions.space8,
                  ),
                  child: MyAssetImageWidget(
                    color: MyColor.getPrimaryColor(),
                    width: 22.sp,
                    height: 16.sp,
                    boxFit: BoxFit.contain,
                    assetPath: MyIcons.lock,
                    isSvg: true,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () => _showConfirmDialog(controller),
                  icon: MyAssetImageWidget(
                    color: MyColor.getPrimaryColor(),
                    width: 20.sp,
                    height: 20.sp,
                    boxFit: BoxFit.contain,
                    assetPath: MyIcons.arrowForward,
                    isSvg: true,
                  ),
                ),
              ),
              spaceDown(Dimensions.space15),
              AppMainSubmitButton(
                text: MyStrings.confirm,
                onTap: () {
                  _showConfirmDialog(controller);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
