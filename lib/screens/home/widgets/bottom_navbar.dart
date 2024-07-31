import 'package:flutter/material.dart';
import 'package:fund_manager/screens/home/screen_home.dart';

class FundManagerBottomNavBar extends StatelessWidget {
  const FundManagerBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: ScreenHome.selectedIndexNotifier,
        builder: (BuildContext ctx, int updatedIndex, Widget? _) {
          return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            currentIndex: updatedIndex,
            onTap: (newIndex){
              ScreenHome.selectedIndexNotifier.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'Transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category')
            ],
          );
        });
  }
}