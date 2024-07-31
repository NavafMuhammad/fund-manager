import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fund_manager/db/category/category_db.dart';
import 'package:fund_manager/db/transactions/transaction_db.dart';
import 'package:fund_manager/models/category/category_model.dart';
import 'package:fund_manager/models/transactions/transaction_model.dart';
import 'package:intl/intl.dart';

class ScreenAddTransactions extends StatefulWidget {
  const ScreenAddTransactions({super.key});

  @override
  State<ScreenAddTransactions> createState() => _ScreenAddTransactionsState();
}

class _ScreenAddTransactionsState extends State<ScreenAddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? categoryID;

  TextEditingController _purposeTextEditingController = TextEditingController();
  TextEditingController _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _purposeTextEditingController,
                decoration: const InputDecoration(
                    hintText: 'Purpose',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _amountTextEditingController,
                decoration: const InputDecoration(
                    hintText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton.icon(
                onPressed: () async {
                  final _tempDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 60)),
                      lastDate: DateTime.now());

                  if (_tempDate == null) {
                    return;
                  } else {
                    setState(() {
                      _selectedDate = _tempDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? 'Select Date'
                    : DateFormat('dd MMMM y').format(_selectedDate!)),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            categoryID = null;
                          });
                        },
                      ),
                      const Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            categoryID = null;
                          });
                        },
                      ),
                      const Text('Expense'),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownButton(
                borderRadius: BorderRadius.circular(15),
                elevation: 0,
                value: categoryID,
                hint: const Text('Select Item'),
                items: (_selectedCategoryType == CategoryType.income
                        ? CategoryDB().incomeCategoryNotifier
                        : CategoryDB().expenseCategoryNotifier)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                    onTap: () {
                      _selectedCategoryModel = e;
                    },
                  );
                }).toList(),
                onChanged: (selectedItem) {
                  setState(() {
                    categoryID = selectedItem;
                  });
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    submitButton();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitButton() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    // _selectedDate
    // _selectedCategoryType
    // _selectedCategoryModel

    final _parsedAmount = double.tryParse(_amountText);

    if (_purposeText.isEmpty) {
      return;
    }
    if (_parsedAmount == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryType == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    final model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );

    TransactionDB().addTransaction(model);
    Navigator.of(context).pop();
  }
}
