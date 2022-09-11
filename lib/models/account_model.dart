import 'package:central_bank/helpers/constants.dart';
import 'package:flutter/cupertino.dart';

class AccountModel {
  String? name;
  int? accountNumber, balance;

  AccountModel({
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  Map<String, dynamic> tojSON() {
    return {
      nameColumn: name,
      accountNumColumn: accountNumber,
      balanceColumn: balance,
    };
  }

  AccountModel.fromJson(Map<String, Object?> json){
    name = json[nameColumn] as String;
    accountNumber = json[accountNumColumn] as int;
    balance = json[balanceColumn] as int;
  }
}
