import 'package:central_bank/helpers/constants.dart';
import 'package:central_bank/models/account_model.dart';
import 'package:central_bank/models/transfer_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  DataBaseHelper._();

  static Database? _db;

  static final DataBaseHelper database = DataBaseHelper._();

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), "AccountsData.db");
    print("entered the initdb method");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (dbb, version) async {
        print("entered the onCreat method");
        await dbb.execute("""
  CREATE TABLE $accountsTable
  ($nameColumn TEXT,
   $accountNumColumn INTEGER, 
   $balanceColumn INTEGER)
""").then((value) {
          AccountModel model1 = AccountModel(
            name: "Harry Potter",
            accountNumber: 68137507,
            balance: 43857,
          );
          AccountModel model2 = AccountModel(
            name: "Lionel Messi",
            accountNumber: 23117505,
            balance: 135439,
          );
          AccountModel model3 = AccountModel(
            name: "John Wick",
            accountNumber: 15305511,
            balance: 93639,
          );
          AccountModel model4 = AccountModel(
            name: "Toni Stark",
            accountNumber: 61690928,
            balance: 142016,
          );
          AccountModel model5 = AccountModel(
            name: "Elon Musk",
            accountNumber: 99906126,
            balance: 1444610,
          );
          AccountModel model6 = AccountModel(
            name: "Jacky Chan",
            accountNumber: 37547714,
            balance: 42362,
          );
          AccountModel model7 = AccountModel(
            name: "Nick Wilde",
            accountNumber: 13668679,
            balance: 15098,
          );
          AccountModel model8 = AccountModel(
            name: " Lord Voldemort",
            accountNumber: 90087442,
            balance: 61674,
          );
          AccountModel model9 = AccountModel(
            name: " Alfred Penny",
            accountNumber: 33145882,
            balance: 49266,
          );
          AccountModel model10 = AccountModel(
            name: "Optimus Prime",
            accountNumber: 63432062,
            balance: 142108,
          );
          insertAccount(model1);
          insertAccount(model2);
          insertAccount(model3);
          insertAccount(model4);
          insertAccount(model5);
          insertAccount(model6);
          insertAccount(model7);
          insertAccount(model8);
          insertAccount(model9);
          insertAccount(model10);
          dbb.execute("""
CREATE TABLE $transfersTable
($fromColumn TEXT,
$toColumn TEXT,
$amountColumn INTEGER)
""");
        });
      },
    );
  }

  Future<void> insertAccount(AccountModel model) async {
    print("entered the insert account method");
    var dbClient = await database.db;
    await dbClient
        ?.insert(
      accountsTable,
      model.tojSON(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      print("$value inserted successfully");
    }).catchError((e) {
      print("error in insert $e");
    });
  }

  Future<void> insertTransferInDataBase(TransferModel model) async {
    print("entered the insert transfer method");
    var dbClient = await database.db;
    await dbClient
        ?.insert(
      transfersTable,
      model.tojSON(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      print("$value record inserted successfully");
    }).catchError((e) {
      print("error in insert in transfer table $e");
    });
  }

  Future<void> updateUser(AccountModel model) async {
    var dbClient = await database.db;
    print("the new model should be: \n ${model.name} ${model.balance}");
    await dbClient?.update(
      accountsTable,
      model.tojSON(),
      where: "$accountNumColumn = ?",
      whereArgs: [model.accountNumber],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AccountModel>> getAllAccounts() async {
    var dbClient = await database.db;
    List<Map<String, Object?>> result = [];
    await dbClient?.query(accountsTable).then((value) {
      result = value;
    });
    return result.map((e) {
      return AccountModel.fromJson(e);
    }).toList();
  }

  Future<List<TransferModel>> getAllTranfers() async {
    var dbClient = await database.db;
    List<Map<String, Object?>> result = [];
    await dbClient?.query(transfersTable).then((value) {
      print("transfers: $value");
      result = value;
    }).catchError((e) {
      print("an error occured while getting transfers record $e");
    });
    return result.map((e) {
      return TransferModel.fromJson(e);
    }).toList();
  }
}
