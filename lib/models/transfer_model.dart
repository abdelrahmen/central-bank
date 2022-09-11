import 'package:central_bank/helpers/constants.dart';

class TransferModel {
  String? from;
  String? to;
  int? amount;

  TransferModel({
    required this.from,
    required this.to,
    required this.amount,
  });

  Map<String, dynamic> tojSON() => {
        fromColumn: from,
        toColumn: to,
        amountColumn: amount,
      };

  TransferModel.fromJson(Map<String, Object?> json){
    from = json[fromColumn] as String;
    to = json[toColumn] as String;
    amount = json[amountColumn] as int;
  }
}
