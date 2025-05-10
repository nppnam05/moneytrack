import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
   int id;

   String name;

   String email;

   String password;

   double totalExpenditure;

   double totalRevenue;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.totalExpenditure,
    required this.totalRevenue,
  });
  
  @override
  String toString() {
    return "$id - $name - $email - $password - $totalExpenditure - $totalRevenue";
  }
}