import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/core/route/route.dart';
import 'package:ovopay/core/utils/util_exporter.dart';
import 'package:ovopay/app/components/credit_card_ui/u_credit_card.dart';

import '../../controller/virtual_cards_controller.dart';

class VcCardsListWidget extends StatelessWidget {
  const VcCardsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VirtualCardsController>(
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(controller.myCardsList.length, (v) {
                var item = controller.myCardsList[v];
                return Padding(
                  padding: EdgeInsetsDirectional.only(end: Dimensions.space10),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        RouteHelper.singleCardsScreen,
                        arguments: item.id.toString(),
                      )?.then((v) {
                        controller.initController(forceLoad: false);
                        controller.initialHistoryData();
                      });
                    },
                    child: CreditCardUi(
                      enableFlipping: false,
                      cardHolderFullName: item.cardHolder?.name ?? "",
                      cardNumber: "************${item.last4 ?? ""}",
                      shouldMaskCardNumber: true,
                      cardProviderLogo: MyAssetImageWidget(
                        height: item.status == AppStatus.VIRTUAL_CARD_CANCELED ? Dimensions.space63 : Dimensions.space35,
                        width: null,
                        assetPath: item.status == AppStatus.VIRTUAL_CARD_CANCELED ? MyImages.canceledImage : MyImages.appLogo,
                        color: item.status == AppStatus.VIRTUAL_CARD_CANCELED ? null : MyColor.white,
                        boxFit: BoxFit.contain,
                      ),
                      validFrom: '${DateConverter.convertIsoToString(item.createdAt ?? DateTime.now().toIso8601String(), outputFormat: "MM")}/${DateConverter.convertIsoToString(item.createdAt ?? DateTime.now().toIso8601String(), outputFormat: "yy")}',
                      validThru: item.formatCardExpiry(),
                      showValidThru: true,
                      balance:
                          // 55.0,
                          AppConverter.formatNumberDouble(item.balance ?? ""),
                      autoHideBalance: true,
                      cvvNumber: "***",
                      showBalance: true,
                      topLeftColor: MyColor.getPrimaryColor(),
                      doesSupportNfc: false,
                      backgroundDecorationImage: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(MyImages.vcCardBgImage),
                      ),
                      placeNfcIconAtTheEnd: true,
                      creditCardType: CreditCardType.visa,
                      cardType: CardType.debit,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
