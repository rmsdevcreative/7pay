import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/image/my_asset_widget.dart';
import 'package:ovopay/app/components/image/my_network_image_widget.dart';
import 'package:ovopay/app/packages/auto_height_grid_view/auto_height_grid_view.dart';
import 'package:ovopay/app/screens/mobile_recharge_screen/views/widgets/mobile_recharge_amount_page.dart';
import 'package:ovopay/app/screens/mobile_recharge_screen/views/widgets/mobile_recharge_contact_select_page.dart';
import 'package:ovopay/core/data/controller/contact/contact_controller.dart';
import 'package:ovopay/core/data/repositories/modules/mobile_recharge/mobile_recharge_repo.dart';
import 'package:ovopay/core/route/route.dart';

import '../../../../../core/utils/util_exporter.dart';
import '../controller/mobile_recharge_controller.dart';
import 'widgets/mobile_recharge_pin_page.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    Get.put(MobileRechargeRepo());
    final controller = Get.put(
      MobileRechargeController(mobileRechargeRepo: Get.find()),
    );

    super.initState();
    // Add listener to track page changes
    _pageController.addListener(_pageChangeListener);

    // Fetch contacts on app startup
    ContactController.to.requestPermissions();

    WidgetsBinding.instance.addPostFrameCallback((v) async {
      await controller.initController();
    });
  }

  void _pageChangeListener() {
    int newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    // Remove listener when the widget is disposed to avoid memory leaks
    _pageController.removeListener(_pageChangeListener);
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? ++_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void _previousPage({int? goToPage}) {
    setState(() {
      _pageController.animateToPage(
        goToPage ?? --_currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: _currentPage == 1 ? MyStrings.selectOperator : MyStrings.mobileRecharge,
      onBackButtonTap: () {
        if (_currentPage != 0) {
          _previousPage();
        } else {
          Get.back();
        }
      },
      actionButton: [
        if (_currentPage == 0)
          CustomAppCard(
            onPressed: () {
              Get.toNamed(RouteHelper.mobileRechargeHistoryScreen);
            },
            width: Dimensions.space40.w,
            height: Dimensions.space40.w,
            padding: EdgeInsetsDirectional.all(Dimensions.space8.w),
            radius: Dimensions.largeRadius.r,
            child: MyAssetImageWidget(
              isSvg: true,
              assetPath: MyIcons.historyInactive,
              width: Dimensions.space24.h,
              height: Dimensions.space24.h,
              color: MyColor.getPrimaryColor(),
            ),
          ),
        spaceSide(Dimensions.space16.w),
      ],
      body: PageView(
        clipBehavior: Clip.none,
        onPageChanged: (value) {
          _currentPage = value;
        },
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MobileRechargeContactSelectPage(
            onSuccessCallback: () {
              _nextPage(goToPage: 1);
            },
          ),
          _buildMobileOperatorPage(),
          MobileRechargeAmountPage(
            onSuccessCallback: () {
              _nextPage(goToPage: 3);
            },
            context: context,
          ),
          MobileRechargePinVerificationPage(context: context),
        ],
      ),
    );
  }

  //Operator Page
  Widget _buildMobileOperatorPage() {
    return GetBuilder<MobileRechargeController>(
      builder: (controller) {
        return AutoHeightGridView(
          itemCount: controller.operatorsDataList.length,
          crossAxisCount: 2,
          mainAxisSpacing: Dimensions.space15.w,
          crossAxisSpacing: Dimensions.space15.w,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          builder: (context, index) {
            var item = controller.operatorsDataList[index];
            return CustomAppCard(
              onPressed: () {
                controller.selectAnOperatorOnTap(item);
                _nextPage(goToPage: 2);
              },
              backgroundColor: item.id == controller.selectedOperator?.id ? MyColor.getPrimaryColor().withValues(alpha: 0.1) : MyColor.getWhiteColor(),
              borderColor: item.id == controller.selectedOperator?.id ? MyColor.getPrimaryColor() : MyColor.getBorderColor(),
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.space20.w,
                horizontal: Dimensions.space20.w,
              ),
              radius: Dimensions.cardExtraRadius.r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyNetworkImageWidget(
                    imageUrl: "${item.getImageUrl()}",
                    boxFit: BoxFit.contain,
                    width: double.infinity,
                    height: Dimensions.space50.h,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
