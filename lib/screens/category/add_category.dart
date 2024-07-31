import 'package:flutter/material.dart';
import 'package:fund_manager/db/category/category_db.dart';
import 'package:fund_manager/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

TextEditingController _textEditingController = TextEditingController();

Future<void> showCategoryPopup(BuildContext context) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(10),
          title: const Text('Add Category'),
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Category Name',
              ),
            ),
            const Row(
              children: [
                RadioButton(title: 'Income', type: CategoryType.income),
                RadioButton(title: 'Expense', type: CategoryType.expense),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  final _name = _textEditingController.text;
                  if (_name.isEmpty) {
                    return;
                  }
                  final _type = selectedCategoryNotifier.value;
                  CategoryDB.instance.insertCategory(CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: _name,
                      type: _type));
                  Navigator.of(ctx).pop();
                  
                },
                child: const Text('Add'))
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  const RadioButton({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final CategoryType type;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder:
                (BuildContext context, CategoryType newCategory, Widget? _) {
              return Radio(
                value: type,
                groupValue: newCategory,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  selectedCategoryNotifier.value = value;
                },
              );
            }),
        Text(title),
      ],
    );
  }
}
