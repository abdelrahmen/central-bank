import 'package:central_bank/helpers/database_helper.dart';
import 'package:central_bank/layout/home_screen.dart';
import 'package:central_bank/provider/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   WidgetsFlutterBinding.ensureInitialized();
   await DataBaseHelper.database.db;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainProvider>(
      create: (context) => MainProvider()..getBankData(),
      child: MaterialApp(
        title: 'Central Bank',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}


