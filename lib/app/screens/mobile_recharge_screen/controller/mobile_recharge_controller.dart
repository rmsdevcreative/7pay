import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ovopay/app/components/snack_bar/show_custom_snackbar.dart';
import 'package:ovopay/core/data/models/global/charges/global_charge_model.dart';
import 'package:ovopay/core/data/models/global/response_model/response_model.dart';
import 'package:ovopay/core/data/models/modules/global/module_transaction_model.dart';
import 'package:ovopay/core/data/models/modules/recharge/recharge_history_response_model.dart';
import 'package:ovopay/core/data/models/modules/recharge/recharge_response_model.dart';
import 'package:ovopay/core/data/models/modules/recharge/recharge_submit_response_model.dart';
import 'package:ovopay/core/data/repositories/modules/mobile_recharge/mobile_recharge_repo.dart';

import '../../../../core/utils/util_exporter.dart';

class MobileRechargeController extends GetxController {
  MobileRechargeRepo mobileRechargeRepo;
  MobileRechargeController({required this.mobileRechargeRepo});

  bool isPageLoading = false;
  TextEditingController phoneNumberOrUserNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  // Get Phone or username or Amount
  String get getPhoneNumber => phoneNumberOrUserNameController.text;
  String get getAmount => amountController.text;
  //Otp Type
  List<String> otpType = [];
  String selectedOtpType = "";
  //current balance
  double userCurrentBalance = 0.0;
  //Charge
  GlobalChargeModel? globalChargeModel;

  //Ngo List
  List<MobileOperatorModel> operatorsDataList = [];
  MobileOperatorModel? selectedOperator;
  //Latest history
  List<MobileRechargeHistoryDataModel> latestHistory = [];

  // Success Model
  ModuleGlobalSubmitTransactionModel? moduleGlobalSubmitTransactionModel;

  //Action ID
  String actionRemark = "mobile_recharge";

  Future initController() async {
    isPageLoading = true;
    update();
    await loadMobileRechargeInfo();
    isPageLoading = false;
    update();
  }

  //Informations
  Future<void> loadMobileRechargeInfo() async {
    try {
      ResponseModel responseModel = await mobileRechargeRepo.mobileRechargeInfoData();
      if (responseModel.statusCode == 200) {
        final microFinanceResponseModel = rechargeResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (microFinanceResponseModel.status == "success") {
          final data = microFinanceResponseModel.data;
          if (data != null) {
            userCurrentBalance = data.getCurrentBalance();

            otpType = data.otpType ?? [];
            globalChargeModel = data.mobileRechargeCharge;

            if (data.mobileOperators != null) {
              operatorsDataList = data.mobileOperators ?? [];
            }
            if (data.latestMobileRechargeHistory != null) {
              latestHistory = data.latestMobileRechargeHistory ?? [];
            }
            update();
          }
        } else {
          CustomSnackBar.error(
            errorList: microFinanceResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
  }

  //Select Otp type
  void selectAnOtpType(String otpType) {
    selectedOtpType = otpType;
    update();
  }

  String getOtpType(String value) {
    return value == "email"
        ? MyStrings.email.tr
        : value == "sms"
            ? MyStrings.phone.tr
            : "";
  }

  //Select Operator
  selectAnOperatorOnTap(MobileOperatorModel value) {
    selectedOperator = value;

    update();
  }

  selectMobileNumberOnTap(
    String value, {
    bool clearSelectedOperator = true,
    MobileOperatorModel? operator,
  }) {
    phoneNumberOrUserNameController.text = value;
    if (clearSelectedOperator) {
      selectedOperator = operator;
    }
    update();
  }

  //Amount text changes
  void onChangeAmountControllerText(String value) {
    amountController.text = value;
    changeInfoWidget();
    update();
  }
  //Charge calculation

  double mainAmount = 0;
  String totalCharge = "";
  String payableAmountText = "";

  void changeInfoWidget() {
    mainAmount = double.tryParse(amountController.text) ?? 0.0;
    update();
    double percent = 0;
    double percentCharge = 0;
    double fixedCharge = 0;
    double tempTotalCharge = 0;
    //Charge calculation
    if (selectedOperator?.percentCharge?.isZero ?? true) {
      percent = double.tryParse(globalChargeModel?.percentCharge ?? "0") ?? 0;
    } else {
      percent = double.tryParse(selectedOperator?.percentCharge ?? "0") ?? 0;
    }
    percentCharge = mainAmount * percent / 100;
    if (selectedOperator?.fixedCharge?.isZero ?? true) {
      fixedCharge = double.tryParse(globalChargeModel?.fixedCharge ?? "0") ?? 0;
    } else {
      fixedCharge = double.tryParse(selectedOperator?.fixedCharge ?? "0") ?? 0;
    }
    tempTotalCharge = percentCharge + fixedCharge;

    double capAmount = double.tryParse(globalChargeModel?.cap ?? "0") ?? 0;

    if (capAmount != -1.0 && capAmount != 1 && tempTotalCharge > capAmount) {
      tempTotalCharge = capAmount;
    }

    totalCharge = AppConverter.formatNumber('$tempTotalCharge', precision: 2);
    double payable = tempTotalCharge + mainAmount;
    payableAmountText = payableAmountText.length > 5 ? AppConverter.roundDoubleAndRemoveTrailingZero(payable.toString()) : AppConverter.formatNumber(payable.toString());
    update();
  }
  //Charge calculation end

  //Submit

  bool isSubmitLoading = false;
  Future<void> submitThisProcess({
    void Function(RechargeSubmitResponseModel)? onSuccessCallback,
    void Function(RechargeSubmitResponseModel)? onVerifyOtpCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await mobileRechargeRepo.mobileRechargeRequest(
        mobile: getPhoneNumber,
        operator: selectedOperator?.id.toString() ?? "-1",
        amount: amountController.text,
        pin: pinController.text,
        otpType: selectedOtpType,
      );
      if (responseModel.statusCode == 200) {
        RechargeSubmitResponseModel rechargeSubmitResponseModel = RechargeSubmitResponseModel.fromJson(responseModel.responseJson);
        if (rechargeSubmitResponseModel.status == "success") {
          if (rechargeSubmitResponseModel.remark == "otp") {
            if (onVerifyOtpCallback != null) {
              onVerifyOtpCallback(rechargeSubmitResponseModel);
            }
            update();
          } else {
            if (rechargeSubmitResponseModel.remark == "pin") {
              if (onSuccessCallback != null) {
                onSuccessCallback(rechargeSubmitResponseModel);
              }
            }
          }
        } else {
          CustomSnackBar.error(
            errorList: rechargeSubmitResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }

        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isSubmitLoading = false;
      update();
    }
  }

  Future<void> pinVerificationProcess({
    void Function(RechargeSubmitResponseModel)? onSuccessCallback,
  }) async {
    try {
      isSubmitLoading = true;
      update();
      ResponseModel responseModel = await mobileRechargeRepo.pinVerificationRequest(pin: pinController.text);
      if (responseModel.statusCode == 200) {
        RechargeSubmitResponseModel rechargeResponseModel = RechargeSubmitResponseModel.fromJson(responseModel.responseJson);

        if (rechargeResponseModel.status == "success") {
          moduleGlobalSubmitTransactionModel = rechargeResponseModel.data?.transaction;
          if (moduleGlobalSubmitTransactionModel != null) {
            if (onSuccessCallback != null) {
              onSuccessCallback(rechargeResponseModel);
            }
          }
        } else {
          CustomSnackBar.error(
            errorList: rechargeResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    } finally {
      isSubmitLoading = false;
      update();
    }
  }
  //Submit end
  //History

  int currentIndex = 0;
  void initialHistoryData() async {
    isHistoryLoading = true;
    page = 0;
    nextPageUrl = null;
    mobileRechargeHistoryList.clear();

    await getMobileRechargeHistoryDataList();
  }

  bool isHistoryLoading = false;
  int page = 1;
  String? nextPageUrl;
  List<MobileRechargeHistoryDataModel> mobileRechargeHistoryList = [];
  Future<void> getMobileRechargeHistoryDataList({bool forceLoad = true}) async {
    try {
      page = page + 1;
      isHistoryLoading = forceLoad;
      update();
      ResponseModel responseModel = await mobileRechargeRepo.mobileRechargeHistory(page);
      if (responseModel.statusCode == 200) {
        final rechargeHistoryResponseModel = rechargeHistoryResponseModelFromJson(
          jsonEncode(responseModel.responseJson),
        );
        if (rechargeHistoryResponseModel.status == "success") {
          nextPageUrl = rechargeHistoryResponseModel.data?.history?.nextPageUrl;
          mobileRechargeHistoryList.addAll(
            rechargeHistoryResponseModel.data?.history?.data ?? [],
          );
        } else {
          CustomSnackBar.error(
            errorList: rechargeHistoryResponseModel.message ?? [MyStrings.somethingWentWrong],
          );
        }
        update();
        isHistoryLoading = false;
        update();
      } else {
        CustomSnackBar.error(errorList: [responseModel.message]);
      }
    } catch (e) {
      printE(e.toString());
    }
    isHistoryLoading = false;
    update();
  }

  bool hasNext() {
    return nextPageUrl != null && nextPageUrl!.isNotEmpty && nextPageUrl != 'null' ? true : false;
  }

  //History end
}
