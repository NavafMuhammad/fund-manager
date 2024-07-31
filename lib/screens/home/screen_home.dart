import 'package:flutter/material.dart';
import 'package:fund_manager/screens/category/add_category.dart';
import 'package:fund_manager/screens/category/screen_category.dart';
import 'package:fund_manager/screens/home/widgets/bottom_navbar.dart';
import 'package:fund_manager/screens/transaction/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const[
    ScreenTransactions(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.teal[200],
          title: const Text('FUND MANAGER'),
        ),
        bottomNavigationBar: FundManagerBottomNavBar(),
        body: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              Navigator.of(context).pushNamed('ScreenAddTransactions');
              print('add transaction');
            } else {
              print('add category');
              showCategoryPopup(context);
            }
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
