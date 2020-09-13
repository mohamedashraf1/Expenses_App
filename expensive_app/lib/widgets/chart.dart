import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './Chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransation;

  Chart(this.recentTransation);

  List<Map<String, Object>> get groupedTransationValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0;
      for (int i = 0; i < recentTransation.length; i++) {
        if (recentTransation[i].date.day == weekDay.day &&
            recentTransation[i].date.month == weekDay.month &&
            recentTransation[i].date.year == weekDay.year)
          totalSum += recentTransation[i].amount;
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get getTotal {
    return groupedTransationValues.fold(0, (sum, element) {
      return sum + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransationValues.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  e['day'], e['amount'], (e['amount'] as double) / getTotal),
            );
          }).toList(),
        ),
      ),
    );
  }
}
