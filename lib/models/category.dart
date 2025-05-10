import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class Category {
  @PrimaryKey(autoGenerate: true)
   int id;

   String name;

   double cost;

  Category({
    required this.id,
    required this.name,
    required this.cost,
  });

  @override
  String toString() {
    return "$id - $name - $cost";
  }
}