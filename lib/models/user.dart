import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
   int? id;

   String name;

   String email;

   double totalExpenditure;

   double totalRevenue;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.totalExpenditure,
    required this.totalRevenue,
  });
  
  @override
  String toString() {
    return "$id - $name - $email - $totalExpenditure - $totalRevenue";
  }
}