import 'package:central_bank/models/account_model.dart';
import 'package:central_bank/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AccountInfoScreen extends StatelessWidget {
  final AccountModel? account;
  final List<AccountModel?>? accounts;
  final index;
  const AccountInfoScreen(
      {super.key, required this.account, required this.accounts, this.index});
  @override
  Widget build(BuildContext context) {
    var selectedItem = accounts?[0];
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Info"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Name: ${account?.name}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, height: 5),
            ),
            Text(
              "Account Number: ${account?.accountNumber}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, height: 5),
            ),
            Consumer<MainProvider>(
              builder: (context, value, child) => Text(
                "Balance: ${NumberFormat.simpleCurrency(
                  locale: "en-US",
                  decimalDigits: 0,
                ).format(value.accounts?[index]?.balance)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20, height: 5),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //transfere money button
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text("To"),
                              ),
                              value: selectedItem,
                              items: accounts
                                  ?.map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text("${e?.name}"),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                selectedItem = value;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          //amount to be transfered
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              label: Text("Amount"),
                              prefixIcon: Icon(Icons.account_box_outlined),
                            ),
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return "please enter the amount to be transfered";
                              } else if (value?.contains(RegExp("[^0-9]")) ??
                                  true) {
                                return "amount can only contain numbers [0-9]";
                              } else if (int.parse(value!) >
                                  int.parse("${account?.balance}") + 100) {
                                return "the account cannot have a balance less than \$100 ";
                              }
                              return null;
                            },
                          ),
                          Consumer<MainProvider>(
                            builder: (context, bank, child) => TextButton(
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  Navigator.pop(context);
                                  if (account != null && selectedItem != null) {
                                    bank.transfereMoney(
                                      from: account!,
                                      to: selectedItem!,
                                      amount: int.parse(amountController.text),
                                    );
                                    bank.insertTransferRecord(
                                      from: account?.name,
                                      to: selectedItem?.name,
                                      amount: int.parse(amountController.text),
                                    );
                                   amountController.clear();
                                  }
                                }
                              },
                              child: const Text("CONFIRM"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text("Transfer Money"),
            ),
          ],
        ),
      ),
    );
  }

  // Widget transferForm(account) => Form(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 border: OutlineInputBorder(),
  //                 label: Text("To (account Number)"),
  //                 prefixIcon: Icon(Icons.account_box_outlined),
  //               ),
  //             ),
  //             TextFormField(),
  //           ],
  //         ),
  //       ),
  //     );
}
