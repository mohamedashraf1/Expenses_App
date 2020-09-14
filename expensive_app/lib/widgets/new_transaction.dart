import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTransaction;

  NewTransaction(this._addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dateTime;

  void _submitData() {
    if (_amountController.text.isEmpty) return;
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty) {
      return;
    }
    if (_dateTime == null) _dateTime = DateTime.now();
    widget._addNewTransaction(
      enteredTitle,
      enteredAmount,
      _dateTime,
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() {
    Platform.isIOS
        ? CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (pickedDate) {
              if (pickedDate == null) return;

              setState(() {
                _dateTime = pickedDate;
              });
            },
            maximumDate: DateTime.now(),
            minimumDate: DateTime(2020),
          )
        : showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          ).then((pickedDate) {
            if (pickedDate == null) return;

            setState(() {
              _dateTime = pickedDate;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            children: <Widget>[
              //CupertinoTextField(placeholder: 'Title',),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'ex: new Shoes',
                ),
                controller: _titleController,
                //onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'ex: 60.5',
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                //onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_dateTime == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_dateTime)}'),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
                onPressed: () => _submitData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
