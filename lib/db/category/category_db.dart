import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fund_manager/models/category/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CategoryDBFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(categoryID);
}

const String CATEGORY_DB_NAME = "category-db";

class CategoryDB implements CategoryDBFunctions {
  //singleton
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  ValueNotifier<List<CategoryModel>> incomeCategoryNotifier = ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final getAllCategories = await getCategories();
    incomeCategoryNotifier.value.clear();
    expenseCategoryNotifier.value.clear();
    await Future.forEach(getAllCategories, (CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryNotifier.value.add(category);
      } else {
        expenseCategoryNotifier.value.add(category);
      }
    });

    incomeCategoryNotifier.notifyListeners();
    expenseCategoryNotifier.notifyListeners();
  }

  @override
  Future<void> deleteCategory(categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.delete(categoryID);
    refreshUI();
  }
}
