import 'package:flutter/foundation.dart';
import 'package:fund_manager/models/transactions/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel value);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(transactionID);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();

  static TransactionDB instance = TransactionDB._internal();

  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionNotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await transactionDB.put(value.id, value);
    refresh();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionDB.values.toList();
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second)=> first.date.compareTo(second.date));
    transactionNotifier.value.clear();
    transactionNotifier.value.addAll(_list);
    transactionNotifier.notifyListeners();
  }
  
  @override
  Future<void> deleteTransaction(transactionID) async{
   final transactionDB = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
   transactionDB.delete(transactionID);
   refresh();
  }


}
