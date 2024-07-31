import 'package:flutter/material.dart';
import 'package:fund_manager/db/transactions/transaction_db.dart';
import 'package:fund_manager/models/transactions/transaction_model.dart';
import 'package:intl/intl.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _){
        return  ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        final _list = newList[index];
        final formatedDate = DateFormat('dd\nMMM').format(_list.date);
        return  Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              child: Text(
                formatedDate,
                textAlign: TextAlign.center,
              ),
            ),
            title: Text("Rs. ${_list.amount}"),
            subtitle: Text(_list.category.name),
            trailing: IconButton(onPressed: (){
              TransactionDB.instance.deleteTransaction(_list.id);
            }, icon: Icon(Icons.delete)),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      itemCount: newList.length,
    );
      },
    );
  }
}
