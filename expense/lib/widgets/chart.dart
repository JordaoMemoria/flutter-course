import 'package:expense/models/transaction.dart';
import 'package:expense/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({super.key, required this.recentTransactions});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = recentTransactions
          .where(
            (element) =>
                element.date.day == weekDay.day &&
                element.date.month == weekDay.month &&
                element.date.year == weekDay.year,
          )
          .fold(
            0.0,
            (previousValue, element) => previousValue += element.amount,
          );

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalAmount => groupedTransactionValues.fold(
        0.0,
        (amount, tx) => amount += tx['amount'] as double,
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'] as String,
                amount: data['amount'] as double,
                total: totalAmount,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
