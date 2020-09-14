import 'package:flutter/material.dart';
import './chart.dart';
import './transaction_list.dart';
import '../models/transaction.dart';

class MyPage extends StatefulWidget {
  List<Transaction> userTransactions;
  bool showChart;
  final PreferredSizeWidget appBar;
  MyPage(this.showChart, this.appBar, this.userTransactions);
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Transaction> get _recentTransacions {
    return widget.userTransactions.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      widget.userTransactions.removeWhere((element) => id == element.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              widget.appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(widget.userTransactions, _deleteTransaction),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (isLandScape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Show Chart",
                style: Theme.of(context).textTheme.headline6,
              ),
              Switch.adaptive(
                activeColor: Theme.of(context).accentColor,
                onChanged: (value) {
                  setState(() {
                    widget.showChart = value;
                  });
                },
                value: widget.showChart,
              ),
            ],
          ),
        if (!isLandScape)
          Container(
            height: (mediaQuery.size.height -
                    widget.appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.3,
            child: Chart(_recentTransacions),
          ),
        if (!isLandScape) txListWidget,
        if (isLandScape)
          widget.showChart
              ? Container(
                  height: (mediaQuery.size.height -
                          widget.appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: Chart(_recentTransacions),
                )
              : txListWidget,
      ],
    );
  }
}
