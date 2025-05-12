import 'package:floor/floor.dart';
import '../models/categories.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Future<List<Categories>> getAllCategories();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<Categories?> getCategoryById(int id);

  @insert
  Future<void> insertCategory(Categories category);

  @update
  Future<void> updateCategory(Categories category);

  @delete
  Future<void> deleteCategory(Categories category);
}