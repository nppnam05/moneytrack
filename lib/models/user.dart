import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  final String email;

  final String password;

  final double totalExpenditure;

  final double totalRevenue;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.totalExpenditure,
    required this.totalRevenue,
  });
}