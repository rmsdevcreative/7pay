import 'package:flutter/material.dart';
import 'package:ovopay/app/components/bottom-sheet/bottom_sheet_bar.dart';
import 'package:ovopay/app/components/bottom-sheet/custom_bottom_sheet_plus.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/components/text/header_text.dart';
import 'package:ovopay/app/screens/global/controller/country_controller.dart';
import 'package:ovopay/core/data/models/country_model/country_model.dart';
import 'package:ovopay/environment.dart';

import '../../../../../core/utils/util_exporter.dart';

class CountryBottomSheet {
  static void countryBottomSheet(
    BuildContext context, {
    CountryData? selectedCountry,
    required void Function(CountryData data) onSelectedData,
  }) {
    CountryController countryController = CountryController();
    countryController.initialize(); // Load country data

    CustomBottomSheetPlus(
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * .82,
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
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
                      spaceDown(Dimensions.space20),
                      Row(
                        children: [
                          Expanded(
                            child: HeaderText(
                              text: MyStrings.selectCountryOfResidence,
                              textStyle: MyTextStyle.headerH3.copyWith(
                                color: MyColor.getHeaderTextColor(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: IconButton(
                              padding: EdgeInsets.all(Dimensions.space3.w),
                              style: IconButton.styleFrom(),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: MyAssetImageWidget(
                                color: MyColor.getHeaderTextColor(),
                                isSvg: true,
                                assetPath: MyIcons.closeButton,
                                width: Dimensions.space40.w,
                                height: Dimensions.space40.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                      spaceDown(Dimensions.space30),
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: countryController.filteredCountries.length,
                          itemBuilder: (context, index) {
                            var countryItem = countryController.filteredCountries[index];

                            return GestureDetector(
                              onTap: () {
                                onSelectedData(countryItem);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.space15,
                                ),
                                margin: EdgeInsetsDirectional.only(
                                  end: Dimensions.space10,
                                ),
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
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.only(
                                              end: Dimensions.space10,
                                            ),
                                            child: MyNetworkImageWidget(
                                              radius: Dimensions.radiusProMax.r,
                                              imageUrl: UrlContainer.countryFlagImageLink.replaceAll(
                                                "{countryCode}",
                                                (countryItem.code ?? Environment.defaultCountryCode).toLowerCase(),
                                              ),
                                              height: Dimensions.space30.w,
                                              width: Dimensions.space30.w,
                                              boxFit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.only(
                                              end: Dimensions.space10,
                                            ),
                                            child: Text(
                                              '+${countryItem.dialCode}',
                                              style: MyTextStyle.sectionTitle3.copyWith(
                                                color: MyColor.getHeaderTextColor(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              countryItem.name ?? "",
                                              style: MyTextStyle.sectionTitle3.copyWith(
                                                color: MyColor.getHeaderTextColor(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      selectedCountry?.code == countryItem.code ? Icons.check_circle_outlined : Icons.circle_outlined,
                                      color: selectedCountry?.code == countryItem.code ? MyColor.getPrimaryColor() : MyColor.getBlackColor().withValues(alpha: 0.35),
                                      weight: 0.5,
                                      size: Dimensions.space25.w,
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
            );
          },
        ),
      ),
    ).show(context);
  }
}
