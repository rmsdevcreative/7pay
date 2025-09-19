// To parse this JSON data, do
//
//     final rechargeResponseModel = rechargeResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/global/charges/global_charge_model.dart';
import 'package:ovopay/core/utils/url_container.dart';

RechargeResponseModel rechargeResponseModelFromJson(String str) => RechargeResponseModel.fromJson(json.decode(str));

String rechargeResponseModelToJson(RechargeResponseModel data) => json.encode(data.toJson());

class RechargeResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  RechargeResponseModel({this.remark, this.status, this.message, this.data});

  factory RechargeResponseModel.fromJson(Map<String, dynamic> json) => RechargeResponseModel(
        remark: json["remark"],
        status: json["status"],
        message: json["message"] == null ? [] : List<String>.from(json["message"]!.map((x) => x)),
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "remark": remark,
        "status": status,
        "message": message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "data": data?.toJson(),
      };
}

class Data {
  List<String>? otpType;
  String? currentBalance;
  GlobalChargeModel? mobileRechargeCharge;
  List<MobileOperatorModel>? mobileOperators;
  List<MobileRechargeHistoryDataModel>? latestMobileRechargeHistory;

  Data({
    this.otpType,
    this.currentBalance,
    this.mobileRechargeCharge,
    this.mobileOperators,
    this.latestMobileRechargeHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["supported_otp_types"] == null ? [] : List<String>.from(json["supported_otp_types"]!.map((x) => x)),
        currentBalance: json["current_balance"],
        mobileRechargeCharge: json["mobile_recharge_charge"] == null ? null : GlobalChargeModel.fromJson(json["mobile_recharge_charge"]),
        mobileOperators: json["operators"] == null
            ? []
            : List<MobileOperatorModel>.from(
                json["operators"]!.map((x) => MobileOperatorModel.fromJson(x)),
              ),
        latestMobileRechargeHistory: json["latest_mobile_recharge"] == null
            ? []
            : List<MobileRechargeHistoryDataModel>.from(
                json["latest_mobile_recharge"]!.map(
                  (x) => MobileRechargeHistoryDataModel.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "supported_otp_types": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "mobile_recharge_charge": mobileRechargeCharge?.toJson(),
        "operators": mobileOperators == null ? [] : List<dynamic>.from(mobileOperators!.map((x) => x.toJson())),
        "latest_mobile_recharge": latestMobileRechargeHistory == null
            ? []
            : List<dynamic>.from(
                latestMobileRechargeHistory!.map((x) => x.toJson()),
              ),
      };

  double getCurrentBalance() {
    try {
      return double.tryParse(currentBalance.toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

class MobileRechargeHistoryDataModel {
  int? id;
  String? userId;
  String? mobileOperatorId;
  String? dialCode;
  String? mobile;
  String? amount;
  String? charge;
  String? total;
  String? trx;
  String? adminFeedback;
  String? status;
  String? createdAt;
  String? updatedAt;
  MobileOperatorModel? mobileOperator;

  MobileRechargeHistoryDataModel({
    this.id,
    this.userId,
    this.mobileOperatorId,
    this.dialCode,
    this.mobile,
    this.amount,
    this.charge,
    this.total,
    this.trx,
    this.adminFeedback,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.mobileOperator,
  });

  factory MobileRechargeHistoryDataModel.fromJson(Map<String, dynamic> json) => MobileRechargeHistoryDataModel(
        id: json["id"],
        userId: json["user_id"]?.toString(),
        mobileOperatorId: json["mobile_operator_id"]?.toString(),
        dialCode: json["dial_code"]?.toString(),
        mobile: json["mobile"]?.toString(),
        amount: json["amount"]?.toString(),
        charge: json["charge"]?.toString(),
        total: json["total"]?.toString(),
        trx: json["trx"]?.toString(),
        adminFeedback: json["admin_feedback"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        mobileOperator: json["mobile_operator"] == null ? null : MobileOperatorModel.fromJson(json["mobile_operator"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "mobile_operator_id": mobileOperatorId,
        "dial_code": dialCode,
        "mobile": mobile,
        "amount": amount,
        "charge": charge,
        "total": total,
        "trx": trx,
        "admin_feedback": adminFeedback,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mobile_operator": mobileOperator?.toJson(),
      };
}

class MobileOperatorModel {
  int? id;
  String? name;
  String? fixedCharge;
  String? percentCharge;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

  MobileOperatorModel({
    this.id,
    this.name,
    this.fixedCharge,
    this.percentCharge,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MobileOperatorModel.fromJson(Map<String, dynamic> json) => MobileOperatorModel(
        id: json["id"],
        name: json["name"]?.toString(),
        fixedCharge: json["fixed_charge"]?.toString(),
        percentCharge: json["percent_charge"]?.toString(),
        image: json["image"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  String? getImageUrl() {
    if (image == null) {
      return null;
    } else {
      var imageUrl = '${UrlContainer.domainUrl}/assets/images/mobile_operator/$image';
      return imageUrl;
    }
  }
}
