import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/custom_company_list_tile_card.dart';
import 'package:ovopay/app/components/text/header_text_smaller.dart';
import 'package:ovopay/app/screens/bill_pay_screen/controller/bill_pay_controller.dart';
import 'package:ovopay/app/screens/global/controller/global_dynamic_form_controller.dart';
import 'package:ovopay/app/screens/global/views/dynamic_form_widget_view.dart';

import '../../../../../core/utils/util_exporter.dart';

class BillPayDynamicFormPage extends StatefulWidget {
  const BillPayDynamicFormPage({
    super.key,
    required this.context,
    required this.onSuccessCallback,
  });
  final VoidCallback onSuccessCallback;

  final BuildContext context;

  @override
  State<BillPayDynamicFormPage> createState() => _BillPayDynamicFormPageState();
}

class _BillPayDynamicFormPageState extends State<BillPayDynamicFormPage> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(
      builder: (billPayController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (billPayController.selectedUtilityCompany != null) ...[
                CustomAppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCompanyListTileCard(
                        padding: EdgeInsets.zero,
                        imagePath: "${billPayController.selectedUtilityCompany?.getCompanyImageUrl()}",
                        title: "${billPayController.selectedUtilityCompany?.name}",
                        subtitle: billPayController.utilityCategoryDataList
                                .firstWhereOrNull(
                                  (e) => e.id?.toString() == billPayController.selectedUtilityCompany?.categoryId?.toString(),
                                )
                                ?.name ??
                            "",
                        trailingTitle: MyStrings.customerID.tr,
                        trailingSubtitle: "${billPayController.selectedUtilityCompany?.id}",
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
              ],
              spaceDown(Dimensions.space16),
              CustomAppCard(
                width: double.infinity,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderTextSmaller(
                        textAlign: TextAlign.center,
                        text: "${MyStrings.billingDetails.tr} ",
                      ),
                      spaceDown(Dimensions.space24),
                      if (billPayController.selectedUtilityCompany != null) ...[
                        DynamicFormWidgetView(
                          formList: billPayController.selectedUtilityCompany?.form?.formData?.list ?? [],
                          autoFillDataList: billPayController.selectedCompanyAutofillData,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              spaceDown(Dimensions.space15),
              AppMainSubmitButton(
                text: MyStrings.continueText,
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Get.find<GlobalDynamicFormController>().submitFormDataData(
                      widget.onSuccessCallback,
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
