import 'package:DailyNotes/src/models/category.dart';
import 'package:DailyNotes/src/repository/repository.dart';

class CategoryActions {
  final _table = 'categories';

  Repository repository;

  CategoryActions() {
    repository = Repository();
  }
  saveCategory(Categories category) async {
    return await repository.insertData(_table, category.toMap());
  }

  readCategory() async {
    return await repository.readData(_table);
  }

  readCategoryById(categoryId) async {
    return await repository.readDataById(_table, categoryId);
  }

  updateCategory(Categories category) async {
    return await repository.updateData(_table, category.toMap());
  }

  deleteCategoryById(categoryId) async {
    return await repository.deleteDataById(_table, categoryId);
  }
}
