import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class Categories {
  @PrimaryKey(autoGenerate: true)
   int? id;

   String name;

   double cost;

  Categories({
    this.id,
    required this.name,
    required this.cost,
  });

  @override
  String toString() {
    return "$id - $name - $cost";
  }
}