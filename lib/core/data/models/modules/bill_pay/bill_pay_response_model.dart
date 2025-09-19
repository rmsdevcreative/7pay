// To parse this JSON data, do
//
//     final billPayCategoryAndCompanyModel = billPayCategoryAndCompanyModelFromJson(jsonString);

import 'dart:convert';

import 'package:ovopay/core/data/models/global/charges/global_charge_model.dart';
import 'package:ovopay/core/data/models/global/formdata/dynamic_fom_submitted_value_model.dart';
import 'package:ovopay/core/data/models/global/formdata/dynamic_forms_map.dart';
import 'package:ovopay/core/utils/url_container.dart';

BillPayCategoryAndCompanyModel billPayCategoryAndCompanyModelFromJson(
  String str,
) =>
    BillPayCategoryAndCompanyModel.fromJson(json.decode(str));

String billPayCategoryAndCompanyModelToJson(
  BillPayCategoryAndCompanyModel data,
) =>
    json.encode(data.toJson());

class BillPayCategoryAndCompanyModel {
  String? remark;
  String? status;
  List<String>? message;
  Data? data;

  BillPayCategoryAndCompanyModel({
    this.remark,
    this.status,
    this.message,
    this.data,
  });

  factory BillPayCategoryAndCompanyModel.fromJson(Map<String, dynamic> json) => BillPayCategoryAndCompanyModel(
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
  List<BillPayCategory>? billCategory;
  List<UserSavedCompany>? userSavedCompanies;
  List<LatestPayBillHistoryModel>? latestPayBillHistory;
  GlobalChargeModel? utilityBillGlobalCharge;

  Data({
    this.otpType,
    this.currentBalance,
    this.billCategory,
    this.userSavedCompanies,
    this.latestPayBillHistory,
    this.utilityBillGlobalCharge,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        otpType: json["supported_otp_types"] == null ? [] : List<String>.from(json["supported_otp_types"]!.map((x) => x)),
        currentBalance: json["current_balance"],
        billCategory: json["bill_category"] == null
            ? []
            : List<BillPayCategory>.from(
                json["bill_category"]!.map((x) => BillPayCategory.fromJson(x)),
              ),
        userSavedCompanies: json["user_companies"] == null
            ? []
            : List<UserSavedCompany>.from(
                json["user_companies"]!.map((x) => UserSavedCompany.fromJson(x)),
              ),
        latestPayBillHistory: json["latest_pay_bill_history"] == null
            ? []
            : List<LatestPayBillHistoryModel>.from(
                json["latest_pay_bill_history"]!.map(
                  (x) => LatestPayBillHistoryModel.fromJson(x),
                ),
              ),
        utilityBillGlobalCharge: json["utility_charge"] == null ? null : GlobalChargeModel.fromJson(json["utility_charge"]),
      );

  Map<String, dynamic> toJson() => {
        "supported_otp_types": otpType == null ? [] : List<dynamic>.from(otpType!.map((x) => x)),
        "current_balance": currentBalance,
        "bill_category": billCategory == null ? [] : List<dynamic>.from(billCategory!.map((x) => x.toJson())),
        "user_companies": userSavedCompanies == null ? [] : List<dynamic>.from(userSavedCompanies!.map((x) => x.toJson())),
        "latest_pay_bill_history": latestPayBillHistory == null ? [] : List<dynamic>.from(latestPayBillHistory!.map((x) => x.toJson())),
        "utility_charge": utilityBillGlobalCharge?.toJson(),
      };
  double getCurrentBalance() {
    try {
      return double.tryParse(currentBalance.toString()) ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
}

class BillPayCategory {
  String? id;
  String? name;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<BillPayCompany>? company;

  BillPayCategory({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.company,
  });

  factory BillPayCategory.fromJson(Map<String, dynamic> json) => BillPayCategory(
        id: json["id"]?.toString(),
        name: json["name"]?.toString(),
        image: json["image"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        company: json["company"] == null
            ? []
            : List<BillPayCompany>.from(
                json["company"]!.map((x) => BillPayCompany.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "company": company == null ? [] : List<dynamic>.from(company!.map((x) => x.toJson())),
      };
  String? getCategoryImageUrl() {
    if (image == null) {
      return null;
    } else {
      var imageUrl = '${UrlContainer.domainUrl}/assets/images/setup_utility/$image';
      return imageUrl;
    }
  }
}

class BillPayCompany {
  int? id;
  String? categoryId;
  String? name;
  String? fixedCharge;
  String? percentCharge;
  String? formId;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  DynamicFormsMap? form;

  BillPayCompany({
    this.id,
    this.categoryId,
    this.name,
    this.fixedCharge,
    this.percentCharge,
    this.formId,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.form,
  });

  factory BillPayCompany.fromJson(Map<String, dynamic> json) => BillPayCompany(
        id: json["id"],
        categoryId: json["category_id"]?.toString(),
        name: json["name"]?.toString(),
        fixedCharge: json["fixed_charge"]?.toString(),
        percentCharge: json["percent_charge"]?.toString(),
        formId: json["form_id"]?.toString(),
        image: json["image"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        form: json["form"] == null ? null : DynamicFormsMap.fromJson(json["form"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "form_id": formId,
        "image": image,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "form": form?.toJson(),
      };
  String? getCompanyImageUrl() {
    if (image == null) {
      return null;
    } else {
      var imageUrl = '${UrlContainer.domainUrl}/assets/images/setup_utility/$image';
      return imageUrl;
    }
  }
}

class LatestPayBillHistoryModel {
  int? id;
  String? userId;
  String? companyId;
  String? amount;
  String? charge;
  String? total;
  String? trx;
  List<UsersDynamicFormSubmittedDataModel>? userData;
  String? adminFeedback;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? statusBadge;
  BillPayCompany? company;

  LatestPayBillHistoryModel({
    this.id,
    this.userId,
    this.companyId,
    this.amount,
    this.charge,
    this.total,
    this.trx,
    this.userData,
    this.adminFeedback,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.statusBadge,
    this.company,
  });

  factory LatestPayBillHistoryModel.fromJson(Map<String, dynamic> json) => LatestPayBillHistoryModel(
        id: json["id"],
        userId: json["user_id"]?.toString(),
        companyId: json["company_id"]?.toString(),
        amount: json["amount"]?.toString(),
        charge: json["charge"]?.toString(),
        total: json["total"]?.toString(),
        trx: json["trx"]?.toString(),
        userData: json["user_data"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["user_data"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
        adminFeedback: json["admin_feedback"]?.toString(),
        status: json["status"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        statusBadge: json["status_badge"]?.toString(),
        company: json["company"] == null ? null : BillPayCompany.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_id": companyId,
        "amount": amount,
        "charge": charge,
        "total": total,
        "trx": trx,
        "user_data": userData == null ? [] : List<dynamic>.from(userData!.map((x) => x.toJson())),
        "admin_feedback": adminFeedback,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status_badge": statusBadge,
        "company": company?.toJson(),
      };
}

class UserSavedCompany {
  int? id;
  int? userId;
  String? companyId;
  String? uniqueId;
  List<UsersDynamicFormSubmittedDataModel>? userData;
  String? createdAt;
  String? updatedAt;
  BillPayCompany? company;

  UserSavedCompany({
    this.id,
    this.userId,
    this.companyId,
    this.uniqueId,
    this.userData,
    this.createdAt,
    this.updatedAt,
    this.company,
  });

  factory UserSavedCompany.fromJson(Map<String, dynamic> json) => UserSavedCompany(
        id: json["id"],
        userId: json["user_id"],
        companyId: json["company_id"]?.toString(),
        uniqueId: json["unique_id"]?.toString(),
        userData: json["user_data"] == null
            ? []
            : List<UsersDynamicFormSubmittedDataModel>.from(
                json["user_data"]!.map(
                  (x) => UsersDynamicFormSubmittedDataModel.fromJson(x),
                ),
              ),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        company: json["company"] == null ? null : BillPayCompany.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "company_id": companyId,
        "unique_id": uniqueId,
        "user_data": userData == null ? [] : List<dynamic>.from(userData!.map((x) => x.toJson())),
        "created_at": createdAt,
        "updated_at": updatedAt,
        "company": company?.toJson(),
      };
}
