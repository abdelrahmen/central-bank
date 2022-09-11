import 'package:central_bank/models/account_model.dart';
import 'package:central_bank/models/transfer_model.dart';
import 'package:central_bank/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransfersScreen extends StatelessWidget {
  const TransfersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: const [
                  SizedBox(
                    width: 130,
                    child: Text(
                      "From",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    child: Text(
                      "To",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      "Amount",
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

            Expanded(
              child: Consumer<MainProvider>(
                builder: (context, bank, child) => (bank.transfers?.isEmpty??true)
                    ? const Center(
                        child: Text("Empty"),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) => buildTransferItem(bank.transfers?[index]),
                        separatorBuilder: (context, index) => Container(
                          color: Colors.grey[300],
                          height: 1,
                        ),
                        itemCount: bank.transfers?.length??1,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTransferItem(
         TransferModel? transfer) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "${transfer?.from}",
            ),
          ),
          //account number
          SizedBox(
            width: 130,
            child: Text(
              "${transfer?.to}",
            ),
          ),

          SizedBox(
            child: Text(NumberFormat.simpleCurrency(
              locale: "en-US",
              decimalDigits: 0,
            ).format(transfer?.amount)),
          ),
        ],
      ),
    );
