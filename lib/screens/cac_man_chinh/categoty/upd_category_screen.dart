import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';
import 'package:moneytrack/utils/database/database_api.dart';

class UpdCategoryScreen extends StatefulWidget {
  const UpdCategoryScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdCategoryScreen> createState() => _UpdCategoryScreenState();
}

class _UpdCategoryScreenState extends State<UpdCategoryScreen> {
  List<Categories> _categories = [];
  Categories? _editingCategory;
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => Divider(),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditDialog(category),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCategory(category),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(Categories category) {
    _editController.text = category.name;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Sửa loại giao dịch'),
            content: TextField(
              controller: _editController,
              decoration: InputDecoration(
                labelText: 'Tên mới',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  String newName = _editController.text.trim();
                  if (newName.isEmpty) return;
                  setState(() {
                    category.name = newName;
                  });
                  await DatabaseApi.updateCategory(
                    category,
                    onSuccess: () {},
                    onError: (e) {},
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Đã sửa thành công!')));
                },
                child: Text('Lưu'),
              ),
            ],
          ),
    );
  }

  Future<void> _loadCategories() async {
    var categoriesFromDb = await DatabaseApi.getAllCategories();
    setState(() {
      _categories = categoriesFromDb;
    });
  }

  void _deleteCategory(Categories category) async {
    await DatabaseApi.deleteCategory(
      category,
      onSuccess: () {},
      onError: (e) {},
    );
    setState(() {
      _categories.remove(category);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Đã xóa loại giao dịch')));
  }
}
