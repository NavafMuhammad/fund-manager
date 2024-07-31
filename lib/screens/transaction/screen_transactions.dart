import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fund_manager/db/category/category_db.dart';
import 'package:fund_manager/db/transactions/transaction_db.dart';
import 'package:fund_manager/models/category/category_model.dart';
import 'package:fund_manager/models/transactions/transaction_model.dart';
import 'package:intl/intl.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final _list = newList[index];
            final formatedDate = DateFormat('dd\nMMM').format(_list.date);
            return Slidable(
              key: Key(_list.id!),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (ctx) {},
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(20),
                    backgroundColor: Color.fromARGB(255, 253, 64, 64),
                  ),
                ],
              ),
              child: Card(
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
                    trailing: _list.type == CategoryType.income
                        ? const Icon(
                            Icons.arrow_circle_up_sharp,
                            size: 30,
                            color: Color.fromARGB(255, 12, 150, 65),
                          )
                        : const Icon(
                            Icons.arrow_circle_down_sharp,
                            size: 30,
                            color: Color.fromARGB(255, 232, 48, 48),
                          )),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: newList.length,
        );
      },
    );
  }
}
