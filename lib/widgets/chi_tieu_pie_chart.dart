import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneytrack/models/categories.dart';

class ChiTieuPieChart extends StatefulWidget {
  final List<Categories> categories;

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
      final color = _getColorForCategory(category.id!);
      final icon = _getIconForCategory(category.id!);

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

  Color _getColorForCategory(int id) {
    switch (id) {
      case 0:
        return Colors.pinkAccent;
      case 1:
        return Colors.orangeAccent;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForCategory(int id) {
    switch (id) {
      case 0:
        return Icons.fastfood;
      case 1:
        return Icons.home;
      case 2:
        return Icons.shopping_bag;
      case 3:
        return Icons.directions_car;
      case 4:
        return Icons.movie;
      case 5:
        return Icons.lightbulb;
      default:
        return Icons.category;
    }
  }
}
