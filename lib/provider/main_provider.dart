import 'package:central_bank/helpers/database_helper.dart';
import 'package:central_bank/models/account_model.dart';
import 'package:central_bank/models/transfer_model.dart';
import 'package:flutter/foundation.dart';

class MainProvider extends ChangeNotifier {
  var dbHelper = DataBaseHelper.database;

  List<AccountModel?>? accounts = [];
  List<TransferModel>? transfers = [];
  var isLoading = false;

  Future<void> getBankData() async {
    isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () async{
      
    await dbHelper.db.then((value) async {
      await dbHelper.getAllAccounts().then(
        (value) async {
          print("getting all acounts in get bank data");
          print(value);
          accounts = value;
          isLoading = false;
        },
      );
      await dbHelper.getAllTranfers().then((value) {
        transfers = value;
        print("getting all records $transfers");
      });
    });
    notifyListeners();
    },);
  }

  void transfereMoney({
    required AccountModel from,
    required AccountModel to,
    required int amount,
  }) async {
    //from (the minus part)
    AccountModel fromModel = AccountModel(
        name: from.name,
        accountNumber: from.accountNumber,
        balance: (from.balance! - amount));
    await dbHelper.updateUser(fromModel);
    //to (the plus part)
    AccountModel toModel = AccountModel(
        name: to.name,
        accountNumber: to.accountNumber,
        balance: (to.balance! + amount));
    await dbHelper.updateUser(toModel).then((value) {
      getBankData();
      notifyListeners();
    });
  }

  void insertTransferRecord({
    required String? from,
    required String? to,
    required int amount,
  }) async {
    TransferModel transfer = TransferModel(
      from: from,
      to: to,
      amount: amount,
    );
    await dbHelper.insertTransferInDataBase(transfer).then((value) async {
      try {
        transfers = await dbHelper.getAllTranfers();
      } catch (e) {
        print("error in getting all transfers: ");
        print(e);
      }
    });
  }
}
