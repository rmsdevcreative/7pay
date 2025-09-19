import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/bottom-sheet/bottom_sheet_header_row.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/buttons/custom_elevated_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/custom_company_list_tile_card.dart';
import 'package:ovopay/app/components/card/custom_list_tile_card.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/no_data.dart';
import 'package:ovopay/app/components/shimmer/faq_shimmer.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/bill_pay_screen/controller/bill_pay_controller.dart';
import 'package:ovopay/app/screens/bill_pay_screen/views/widgets/bill_pay_select_bill_type_category_widget.dart';
import 'package:ovopay/core/data/models/modules/bill_pay/bill_pay_response_model.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/util_exporter.dart';

class BillPaySelectBillTypePageWidget extends StatelessWidget {
  final BuildContext context;
  const BillPaySelectBillTypePageWidget({
    super.key,
    required this.context,
    required this.onSuccessCallback,
  });
  final VoidCallback onSuccessCallback;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(
      builder: (billPayController) {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Skeletonizer(
                  enabled: billPayController.isPageLoading,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.space16.h),
                    child: Column(
                      children: [
                        CustomAppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HeaderText(
                                textAlign: TextAlign.center,
                                text: MyStrings.biller.tr,
                                textStyle: MyTextStyle.sectionTitle.copyWith(
                                  color: MyColor.getHeaderTextColor(),
                                ),
                              ),
                              spaceDown(Dimensions.space8),
                              RoundedTextField(
                                controller: billPayController.companyNameController,
                                showLabelText: false,
                                labelText: MyStrings.enterBillersName.tr,
                                hintText: MyStrings.enterBillersName.tr,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                suffixIcon: IconButton(
                                  onPressed: null,
                                  icon: MyAssetImageWidget(
                                    color: MyColor.getPrimaryColor(),
                                    width: Dimensions.space24.w,
                                    height: Dimensions.space24.w,
                                    boxFit: BoxFit.contain,
                                    assetPath: MyIcons.searchIcon,
                                    isSvg: true,
                                  ),
                                ),
                                onChanged: (value) {
                                  billPayController.filterUtilityBillByCompanyName(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        if (billPayController.companyNameController.text.trim().isEmpty) ...[
                          spaceDown(Dimensions.space16),
                          BillPayCategoryWidgetCard(),
                        ],
                        if (billPayController.companyNameController.text.isEmptyString && billPayController.savedUtilityCompanyDataList.isNotEmpty) ...[
                          spaceDown(Dimensions.space16),
                          CustomAppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Saved account
                                HeaderText(
                                  text: MyStrings.savedBankCard.tr,
                                  textStyle: MyTextStyle.sectionTitle2.copyWith(
                                    color: MyColor.getHeaderTextColor(),
                                  ),
                                ),
                                spaceDown(Dimensions.space8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: billPayController.getUniqueCompanyIdList().length,
                                  itemBuilder: (context, index) {
                                    var item = billPayController.getUniqueCompanyIdList()[index];
                                    bool isLastIndex = index == billPayController.getUniqueCompanyIdList().length - 1;
                                    return CustomListTileCard(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.space15.h,
                                      ),
                                      leading: CustomAppCard(
                                        width: Dimensions.space45.w,
                                        height: Dimensions.space45.w,
                                        radius: Dimensions.largeRadius.r,
                                        padding: EdgeInsetsDirectional.all(
                                          Dimensions.space4.w,
                                        ),
                                        child: MyNetworkImageWidget(
                                          boxFit: BoxFit.scaleDown,
                                          imageUrl: item.company?.getCompanyImageUrl() ?? "",
                                          isProfile: false,
                                          radius: Dimensions.largeRadius.r,
                                          width: Dimensions.space40.w,
                                          height: Dimensions.space40.w,
                                        ),
                                      ),
                                      subtitleStyle: MyTextStyle.sectionSubTitle1.copyWith(
                                        color: MyColor.getBodyTextColor(),
                                      ),
                                      imagePath: "",
                                      title: item.company?.name ?? "",
                                      subtitle: "${billPayController.savedUtilityCompanyDataList.where((value) => value.companyId == item.companyId).toList().length} ${MyStrings.addedAccount.tr}",
                                      showBorder: !isLastIndex,
                                      onPressed: () {
                                        if (item.company != null) {
                                          billPayController.selectedUtilityCompanyOnTap(
                                            item.company,
                                          );
                                          billPayController.selectedUtilityCompanyAutofillDataOnTap(
                                            [],
                                          );
                                          CustomBottomSheetPlus(
                                            child: SafeArea(
                                              child: buildBillSaveAccountAddBottomSheet(
                                                company: item.company!,
                                                onPayNOwButtonClick: () {
                                                  billPayController.selectedUtilityCompanyOnTap(
                                                    item.company,
                                                  );
                                                  onSuccessCallback();
                                                },
                                              ),
                                            ),
                                          ).show(context);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              var isCategorySelected = billPayController.selectedUtilityCategory != null;
              var dataList = isCategorySelected ? billPayController.selectedUtilityCategory?.company ?? [] : billPayController.filterUtilityBillCompanyDataList;
              if (billPayController.isPageLoading) {
                return FaqShimmer();
              }
              if (dataList.isEmpty) {
                return SingleChildScrollView(
                  child: CustomAppCard(
                    child: NoDataWidget(
                      text: MyStrings.noMatchingBillerFound.tr,
                    ),
                  ),
                );
              }

              return CustomAppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderText(
                      text: MyStrings.allBillers.tr,
                      textStyle: MyTextStyle.sectionTitle2.copyWith(
                        color: MyColor.getHeaderTextColor(),
                      ),
                    ),
                    spaceDown(Dimensions.space16),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              BuildContext context,
                              int index,
                            ) {
                              var item = dataList[index];
                              bool isLastIndex = index == dataList.length - 1;
                              return CustomCompanyListTileCard(
                                onPressed: () {
                                  billPayController.selectedUtilityCompanyOnTap(
                                    item,
                                  );
                                  billPayController.selectedUtilityCompanyAutofillDataOnTap(
                                    [],
                                  );
                                  CustomBottomSheetPlus(
                                    child: SafeArea(
                                      child: buildBillSaveAccountAddBottomSheet(
                                        company: item,
                                        onPayNOwButtonClick: () {
                                          billPayController.selectedUtilityCompanyOnTap(
                                            item,
                                          );
                                          onSuccessCallback();
                                        },
                                      ),
                                    ),
                                  ).show(context);
                                },
                                imagePath: item.getCompanyImageUrl() ?? "",
                                title: "${item.name}",
                                subtitle: "${billPayController.utilityCategoryDataList.firstWhere((e) => e.id?.toString() == item.categoryId?.toString()).name}",
                                showBorder: !isLastIndex,
                                titleStyle: MyTextStyle.sectionSubTitle1.copyWith(fontWeight: FontWeight.w600),
                                subtitleStyle: MyTextStyle.caption2Style.copyWith(
                                  color: MyColor.getBodyTextColor(),
                                ),
                              );
                            }, childCount: dataList.length),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget buildBillSaveAccountAddBottomSheet({
    required BillPayCompany company,
    required VoidCallback onPayNOwButtonClick,
  }) {
    return PopScope(
      canPop: true,
      child: GetBuilder<BillPayController>(
        builder: (controller) {
          var dataList = controller.savedUtilityCompanyDataList.where((value) => value.company?.id == company.id).toList();
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxHeight: ScreenUtil().screenHeight / 1.2,
            ),
            child: Column(
              children: [
                BottomSheetHeaderRow(header: MyStrings.selectSavedAccount),
                spaceDown(Dimensions.space10),
                CustomCompanyListTileCard(
                  padding: EdgeInsetsDirectional.symmetric(
                    vertical: Dimensions.space10.w,
                    horizontal: Dimensions.space10.w,
                  ),
                  leading: CustomAppCard(
                    width: Dimensions.space45.w,
                    height: Dimensions.space45.w,
                    radius: Dimensions.largeRadius.r,
                    padding: EdgeInsetsDirectional.zero,
                    child: MyNetworkImageWidget(
                      radius: Dimensions.largeRadius.r,
                      boxFit: BoxFit.scaleDown,
                      imageUrl: company.getCompanyImageUrl() ?? "",
                      isProfile: false,
                      width: Dimensions.space40.w,
                      height: Dimensions.space40.w,
                    ),
                  ),
                  showBorder: false,
                  imagePath: company.getCompanyImageUrl() ?? "",
                  title: "${company.name}",
                ),
                spaceDown(Dimensions.space10),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: MyColor.getBorderColor(),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                ),
                spaceDown(Dimensions.space10),
                if (dataList.isNotEmpty) ...[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(dataList.length, (index) {
                          var item = dataList[index];
                          bool isLastIndex = index == dataList.length - 1;
                          return CustomListTileCard(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.space20.h,
                              horizontal: Dimensions.space20.w,
                            ),
                            leading: CustomAppCard(
                              width: Dimensions.space40.w,
                              height: Dimensions.space40.w,
                              radius: Dimensions.largeRadius.r,
                              padding: EdgeInsetsDirectional.all(
                                Dimensions.space4.w,
                              ),
                              child: MyNetworkImageWidget(
                                boxFit: BoxFit.scaleDown,
                                imageUrl: item.company?.getCompanyImageUrl() ?? "",
                                isProfile: false,
                                radius: Dimensions.largeRadius.r,
                                width: Dimensions.space30.w,
                                height: Dimensions.space30.w,
                              ),
                            ),
                            subtitleStyle: MyTextStyle.sectionSubTitle1.copyWith(color: MyColor.getBodyTextColor()),
                            imagePath: "",
                            title: item.uniqueId ?? "",
                            // subtitle: (item.uniqueId ?? ""),
                            showBorder: !isLastIndex,
                            trailing: IconButton(
                              onPressed: () {
                                if (controller.isDeleteSaveAccountIDLoading == "-1") {
                                  controller.deleteSavedAccount(
                                    accountID: item.id?.toString() ?? "",
                                  );
                                }
                              },
                              icon: (controller.isDeleteSaveAccountIDLoading == item.id?.toString())
                                  ? SizedBox(
                                      width: Dimensions.space20.w,
                                      height: Dimensions.space20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: MyColor.getPrimaryColor(),
                                      ),
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: MyColor.redLightColor,
                                    ),
                            ),
                            onPressed: () {
                              controller.selectedUtilityCompanyAutofillDataOnTap(
                                item.userData ?? [],
                              );
                              onPayNOwButtonClick();
                              Get.back();
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.space10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.link,
                            color: MyColor.getPrimaryColor(),
                            size: Dimensions.space30.w,
                          ),
                          spaceSide(Dimensions.space10),
                          Expanded(
                            child: Text(
                              MyStrings.addUtilityAccountMsg.tr,
                              style: MyTextStyle.sectionSubTitle1.copyWith(
                                color: MyColor.getBodyTextColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                spaceDown(Dimensions.space20),
                CustomElevatedBtn(
                  radius: Dimensions.largeRadius.r,
                  borderColor: MyColor.getPrimaryColor(),
                  bgColor: MyColor.getWhiteColor(),
                  textColor: MyColor.getPrimaryColor(),
                  text: MyStrings.payNow,
                  icon: Icon(Icons.send, color: MyColor.getPrimaryColor()),
                  onTap: () {
                    controller.selectedUtilityCompanyAutofillDataOnTap([]);
                    onPayNOwButtonClick();
                    Get.back();
                  },
                ),
                spaceDown(Dimensions.space10),
                CustomElevatedBtn(
                  radius: Dimensions.largeRadius.r,
                  bgColor: MyColor.getPrimaryColor(),
                  text: MyStrings.addAccount,
                  icon: Icon(Icons.add, color: MyColor.getWhiteColor()),
                  onTap: () {
                    Get.back();
                    Get.toNamed(RouteHelper.billPayAddNewAccountScreen)?.then((
                      v,
                    ) {
                      controller.initController(forceLoad: false);
                    });
                  },
                ),
                spaceDown(Dimensions.space20),
              ],
            ),
          );
        },
      ),
    );
  }
}
