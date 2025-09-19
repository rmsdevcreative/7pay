import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/buttons/app_main_submit_button.dart';
import 'package:ovopay/app/components/card/custom_card.dart';
import 'package:ovopay/app/components/card/my_custom_scaffold.dart';
import 'package:ovopay/app/components/text-field/rounded_text_field.dart';
import 'package:ovopay/app/components/text/header_text_smaller.dart';
import 'package:ovopay/app/screens/bill_pay_screen/controller/bill_pay_controller.dart';
import 'package:ovopay/app/screens/global/controller/global_dynamic_form_controller.dart';
import 'package:ovopay/app/screens/global/views/dynamic_form_widget_view.dart';

import '../../../../../core/utils/util_exporter.dart';

class BillPayAddAccountScreen extends StatefulWidget {
  const BillPayAddAccountScreen({super.key});

  @override
  State<BillPayAddAccountScreen> createState() => _BillPayAddAccountScreenState();
}

class _BillPayAddAccountScreenState extends State<BillPayAddAccountScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      pageTitle: MyStrings.addBillerAccount,
      body: GetBuilder<BillPayController>(
        builder: (controller) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                //ADD CLEARING LOGIC HERE
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomAppCard(
                    width: double.infinity,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeaderTextSmaller(
                            textAlign: TextAlign.center,
                            text: "${MyStrings.accountInformation.tr} ",
                          ),
                          spaceDown(Dimensions.space24),
                          RoundedTextField(
                            isRequired: true,
                            controller: controller.uniqueIDController,
                            showLabelText: true,
                            labelText: MyStrings.uniqueID,
                            hintText: "",
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return MyStrings.fieldErrorMsg.tr;
                              } else {
                                return null;
                              }
                            },
                          ),
                          spaceDown(Dimensions.space16),
                          DynamicFormWidgetView(
                            formList: controller.selectedUtilityCompany == null ? controller.selectedUtilityCompany?.form?.formData?.list ?? [] : controller.selectedUtilityCompany?.form?.formData?.list ?? [],
                          ),
                        ],
                      ),
                    ),
                  ),
                  spaceDown(Dimensions.space15),
                  AppMainSubmitButton(
                    isLoading: controller.isSubmitSaveCompanyAccountLoading,
                    text: MyStrings.save,
                    onTap: () {
                      if (formKey.currentState?.validate() ?? false) {
                        GlobalDynamicFormController dynamicFormController = Get.find();
                        dynamicFormController.submitFormDataData(() {
                          controller.submitSaveAccountProcess(
                            dynamicFormList: dynamicFormController.formList,
                            onSuccessCallback: () {
                              Get.back(result: "success");
                            },
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
