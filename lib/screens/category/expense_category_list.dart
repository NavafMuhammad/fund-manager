import 'package:flutter/material.dart';
import 'package:fund_manager/db/category/category_db.dart';
import 'package:fund_manager/models/category/category_model.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryNotifier,
        builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _category = newList[index];
                return Card(
                  child: ListTile(
                    title: Text(_category.name),
                    trailing: IconButton(
                      onPressed: () {
                        CategoryDB.instance.deleteCategory(_category.id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: newList.length);
        });
  }
}
