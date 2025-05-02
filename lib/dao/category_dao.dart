import 'package:floor/floor.dart';
import '../models/category.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories')
  Future<List<Category>> getAllCategories();

  @Query('SELECT * FROM categories WHERE id = :id')
  Future<Category?> getCategoryById(int id);

  @insert
  Future<void> insertCategory(Category category);

  @update
  Future<void> updateCategory(Category category);

  @delete
  Future<void> deleteCategory(Category category);
}