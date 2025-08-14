import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Transaction {
  final String category;
  final double amount;

  Transaction({required this.category, required this.amount});
}

class PieChartScreen extends StatelessWidget {
  final List<Transaction> transactions;

  PieChartScreen({Key? key, required this.transactions}) : super(key: key);

  // Agrupa e soma os valores por categoria
  Map<String, double> get categoryTotals {
    Map<String, double> dataMap = {};
    for (var tx in transactions) {
      dataMap[tx.category] = (dataMap[tx.category] ?? 0) + tx.amount;
    }
    return dataMap;
  }

  // Cores para as fatias
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    final dataMap = categoryTotals;
    final total = dataMap.values.fold(0.0, (sum, val) => sum + val);

    if (dataMap.isEmpty) {
      return const Center(child: Text('No data to display'));
    }

    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Expenses by Category',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: List.generate(dataMap.length, (index) {
                      final category = dataMap.keys.elementAt(index);
                      final value = dataMap[category]!;
                      final percent = (value / total) * 100;

                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: value,
                        title: '${percent.toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legenda
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(dataMap.length, (index) {
                  final category = dataMap.keys.elementAt(index);
                  final color = colors[index % colors.length];

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: color,
                      ),
                      const SizedBox(width: 6),
                      Text(category),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
