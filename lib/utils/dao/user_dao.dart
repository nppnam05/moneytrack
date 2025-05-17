import 'package:floor/floor.dart';
import '../../models/user.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users WHERE email = :email LIMIT 1')
  Future<User?> findUserByEmail(String email);

  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM users WHERE id = :id')
  Future<User?> getUserById(int id);

  @insert
  Future<int> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);
}
