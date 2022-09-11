import 'package:central_bank/layout/account_info_screen.dart';
import 'package:central_bank/layout/transfers_screen.dart';
import 'package:central_bank/models/account_model.dart';
import 'package:central_bank/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CENTRAL BANK"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //name acc balance
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: const [
                  SizedBox(
                    width: 130,
                    child: Text(
                      "Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Text(
                      "Acc. Num.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //grey line
            Container(
              color: Colors.grey[300],
              height: 1,
            ),
            //main data
            Expanded(
              child: Consumer<MainProvider>(
                builder: (context, bank, child) => (bank.isLoading)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => buildTableItem(context,
                            bank.accounts?[index], bank.accounts, index),
                        separatorBuilder: (context, index) => Container(
                          color: Colors.grey[300],
                          height: 1,
                        ),
                        itemCount: bank.accounts?.length ?? 1,
                      ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransfersScreen(),
                  ),
                );
              },
              child: const Text("Transfers Table"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTableItem(
        context, AccountModel? account, List<AccountModel?>? accounts, index) =>
    InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountInfoScreen(
              account: account,
              accounts: accounts?.where((e) {
                return (e?.accountNumber != account?.accountNumber);
              }).toList(),
              index: index,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(
                "${account?.name}",
              ),
            ),
            //account number
            SizedBox(
              width: 130,
              child: Text(
                "${account?.accountNumber}",
              ),
            ),

            SizedBox(
              child: Text(NumberFormat.simpleCurrency(
                locale: "en-US",
                decimalDigits: 0,
              ).format(account?.balance)),
            ),
          ],
        ),
      ),
    );
