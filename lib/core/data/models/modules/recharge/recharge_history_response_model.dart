// To parse this JSON data, do
//
//     final rechargeHistoryResponseModel = rechargeHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/modules/recharge/recharge_response_model.dart';

RechargeHistoryResponseModel rechargeHistoryResponseModelFromJson(String str) => RechargeHistoryResponseModel.fromJson(json.decode(str));

String rechargeHistoryResponseModelToJson(RechargeHistoryResponseModel data) => json.encode(data.toJson());

class RechargeHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  RechargeHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory RechargeHistoryResponseModel.fromJson(Map<String, dynamic> json) => RechargeHistoryResponseModel(
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
  History? history;

  Data({this.history});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        history: json["recharges"] == null ? null : History.fromJson(json["recharges"]),
      );

  Map<String, dynamic> toJson() => {"recharges": history?.toJson()};
}

class History {
  List<MobileRechargeHistoryDataModel>? data;

  String? nextPageUrl;
  String? path;

  History({this.data, this.nextPageUrl, this.path});

  factory History.fromJson(Map<String, dynamic> json) => History(
        data: json["data"] == null
            ? []
            : List<MobileRechargeHistoryDataModel>.from(
                json["data"]!.map(
                  (x) => MobileRechargeHistoryDataModel.fromJson(x),
                ),
              ),
        nextPageUrl: json["next_page_url"]?.toString(),
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
      };
}
