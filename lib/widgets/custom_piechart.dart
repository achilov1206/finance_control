import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/category.dart';
import '../models/category_total_amount.dart';

class CustomPieChart extends StatelessWidget {
  final List<CategoryTotalAmount> categoryTotalAmountData;
  const CustomPieChart({
    Key? key,
    required this.categoryTotalAmountData,
  }) : super(key: key);

  List<Widget> chartLabels(List<CategoryTotalAmount> catTotalAmountData) {
    List<Widget> _chartLabels = [];
    for (CategoryTotalAmount data in catTotalAmountData) {
      _chartLabels.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: data.color,
                ),
                Text(
                  Category.getCategoryString(data.category!.categoryType!) +
                      ':',
                ),
                const SizedBox(width: 10),
                Text(data.category!.title!),
              ],
            ),
            Text(data.totalAmount!.toStringAsFixed(2)),
          ],
        ),
      );
    }
    return _chartLabels;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CategoryTotalAmount, String>> _seriesPieData = [
      charts.Series(
        id: 'monthly_chart',
        data: categoryTotalAmountData,
        domainFn: (CategoryTotalAmount cat, _) => cat.category!.title!,
        measureFn: (CategoryTotalAmount cat, _) => cat.totalAmount,
        colorFn: (CategoryTotalAmount cat, _) =>
            charts.ColorUtil.fromDartColor(cat.color!),
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: categoryTotalAmountData.isNotEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 200,
                  child: charts.PieChart<String>(
                    _seriesPieData,
                    animate: true,
                  ),
                ),
                ...chartLabels(categoryTotalAmountData),
              ],
            )
          : const Center(
              child: Text('There are no transactions'),
            ),
    );
  }
}
