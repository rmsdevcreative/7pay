// To parse this JSON data, do
//
//     final rechargeSubmitResponseModel = rechargeSubmitResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/modules/global/module_transaction_model.dart';

RechargeSubmitResponseModel rechargeSubmitResponseModelFromJson(String str) => RechargeSubmitResponseModel.fromJson(json.decode(str));

String rechargeSubmitResponseModelToJson(RechargeSubmitResponseModel data) => json.encode(data.toJson());

class RechargeSubmitResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  RechargeSubmitResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RechargeSubmitResponseModel.fromJson(Map<String, dynamic> json) => RechargeSubmitResponseModel(
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
  ModuleGlobalSubmitTransactionModel? transaction;

  Data({this.transaction});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        transaction: json["recharge"] == null ? null : ModuleGlobalSubmitTransactionModel.fromJson(json["recharge"]),
      );

  Map<String, dynamic> toJson() => {"recharge": transaction?.toJson()};
}
