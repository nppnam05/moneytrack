import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneytrack/models/category.dart';

class ChiTieuPieChart extends StatefulWidget {
  final List<Category> categories;

  const ChiTieuPieChart({Key? key, required this.categories}) : super(key: key);

  @override
  _ChiTieuPieChartState createState() => _ChiTieuPieChartState();
}

class _ChiTieuPieChartState extends State<ChiTieuPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    double totalCost = widget.categories.fold(0, (sum, c) => sum + c.cost);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 1.2,
          child: PieChart(
            PieChartData(
              sections: _generateSections(totalCost),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                      touchedIndex = -1;
                    } else {
                      touchedIndex = response!.touchedSection!.touchedSectionIndex;
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(double total) {
    return List.generate(widget.categories.length, (index) {
      final category = widget.categories[index];
      final isTouched = index == touchedIndex;
      double percent = total == 0 ? 0 : (category.cost / total) * 100;
      final color = _getColorForCategory(category.name);
      final icon = _getIconForCategory(category.name);

      return PieChartSectionData(
        color: color,
        value: percent,
        title: '${percent.toStringAsFixed(1)}%',
        radius: isTouched ? 90 : 70,
        titleStyle: TextStyle(
          fontSize: isTouched ? 18 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _buildBadge(icon, color, isTouched ? 40 : 30),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  Widget _buildBadge(IconData icon, Color bgColor, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: bgColor, width: 2),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Center(
        child: Icon(icon, size: size * 0.6, color: bgColor),
      ),
    );
  }

  Color _getColorForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'food':
        return Colors.pinkAccent;
      case 'rental':
        return Colors.orangeAccent;
      case 'shopping':
        return Colors.blueGrey;
      case 'transport':
        return Colors.teal;
      case 'entertainment':
        return Colors.purple;
      case 'utilities':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'food':
        return Icons.fastfood;
      case 'rental':
        return Icons.home;
      case 'shopping':
        return Icons.shopping_bag;
      case 'transport':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.lightbulb;
      default:
        return Icons.category;
    }
  }
}
