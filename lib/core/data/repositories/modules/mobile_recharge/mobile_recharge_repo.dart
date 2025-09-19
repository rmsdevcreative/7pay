import 'package:ovopay/core/data/models/global/response_model/response_model.dart';

import '../../../../utils/util_exporter.dart';
import '../../../services/service_exporter.dart';

class MobileRechargeRepo {
  Future<ResponseModel> mobileRechargeInfoData() async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.rechargeEndPoint}';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> mobileRechargeRequest({
    String amount = "",
    String mobile = "",
    String operator = "",
    String pin = "",
    String otpType = "",
    String remark = "mobile_recharge",
  }) async {
    Map<String, String> params = {
      'amount': amount,
      'mobile_number': mobile,
      'operator': operator,
      'pin': pin,
      'verification_type': otpType,
      'remark': remark,
    };
    String url = '${UrlContainer.baseUrl}${UrlContainer.rechargeStoreEndPoint}';
    final response = await ApiService.postRequest(url, params);
    return response;
  }

  Future<ResponseModel> mobileRechargeHistory(int page) async {
    String url = '${UrlContainer.baseUrl}${UrlContainer.rechargeHistoryEndPoint}?page=$page';
    final response = await ApiService.getRequest(url);
    return response;
  }

  Future<ResponseModel> pinVerificationRequest({
    String pin = "",
    String remark = "mobile_recharge",
  }) async {
    Map<String, String> params = {'pin': pin, 'remark': remark};
    String url = '${UrlContainer.baseUrl}${UrlContainer.verifyPin}';
    final response = await ApiService.postRequest(url, params);
    return response;
  }
}
