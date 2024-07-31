import 'package:flutter/material.dart';
import 'package:fund_manager/models/category/category_model.dart';
import 'package:fund_manager/models/transactions/transaction_model.dart';
import 'package:fund_manager/screens/add_transactions/screen_add_transactions.dart';
import 'package:fund_manager/screens/home/screen_home.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
    Hive.registerAdapter(TransactionModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes: {
        'ScreenAddTransactions' : (context) => const ScreenAddTransactions()
      },
      home: const ScreenHome(),
    );
  }
}
