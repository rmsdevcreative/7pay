// To parse this JSON data, do
//
//     final billPayHistoryResponseModel = billPayHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/modules/bill_pay/bill_pay_response_model.dart';

BillPayHistoryResponseModel billPayHistoryResponseModelFromJson(String str) => BillPayHistoryResponseModel.fromJson(json.decode(str));

String billPayHistoryResponseModelToJson(BillPayHistoryResponseModel data) => json.encode(data.toJson());

class BillPayHistoryResponseModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  BillPayHistoryResponseModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BillPayHistoryResponseModel.fromJson(Map<String, dynamic> json) => BillPayHistoryResponseModel(
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
        history: json["utility_bills"] == null ? null : History.fromJson(json["utility_bills"]),
      );

  Map<String, dynamic> toJson() => {"utility_bills": history?.toJson()};
}

class History {
  List<LatestPayBillHistoryModel>? data;

  String? nextPageUrl;
  String? path;

  History({this.data, this.nextPageUrl, this.path});

  factory History.fromJson(Map<String, dynamic> json) => History(
        data: json["data"] == null
            ? []
            : List<LatestPayBillHistoryModel>.from(
                json["data"]!.map((x) => LatestPayBillHistoryModel.fromJson(x)),
              ),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
      };
}
