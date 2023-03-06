import 'package:expense/widgets/chart.dart';
import 'package:expense/screens/new_transaction.dart';
import 'package:expense/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:expense/models/transaction.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool _showChart = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't4',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't5',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't6',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'New shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't8',
      title: 'Weekly Groceries',
      amount: 16.53,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
          (tx) => tx.date.isAfter(
            DateTime.now().subtract(
              const Duration(
                days: 7,
              ),
            ),
          ),
        )
        .toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: selectedDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(onAdd: _addNewTransaction);
      },
    );
  }

  Widget _builderLandscape() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Show Chart',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch.adaptive(
                  activeColor: Theme.of(context).primaryColor,
                  value: _showChart,
                  onChanged: (value) {
                    setState(() {
                      _showChart = !_showChart;
                    });
                  }),
            ],
          ),
          _showChart
              ? Expanded(
                  child: Chart(
                    recentTransactions: _recentTransactions,
                  ),
                )
              : Expanded(
                  child: TransactionList(
                    transactions: _userTransactions,
                    onDelete: (id) => _deleteTransaction(id),
                  ),
                ),
        ],
      );

  Widget _builderPortrait() => Column(
        children: [
          Expanded(
            flex: 2,
            child: Chart(
              recentTransactions: _recentTransactions,
            ),
          ),
          Expanded(
            flex: 7,
            child: TransactionList(
              transactions: _userTransactions,
              onDelete: (id) => _deleteTransaction(id),
            ),
          ),
        ],
      );

  Widget _builderCupertionScaffold(bool isLandscape) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text(
            'Expenses',
          ),
          trailing: GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(
              CupertinoIcons.add,
              size: 25,
            ),
          ),
        ),
        child: pageBody(isLandscape),
      );

  Widget _builderMaterialScaffold(bool isLandscape) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: pageBody(isLandscape),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
          ),
          onPressed: () => _startAddNewTransaction(context),
        ),
      );

  Widget pageBody(bool isLandscape) => SafeArea(
        child: isLandscape ? _builderLandscape() : _builderPortrait(),
      );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    var isLandscape = mediaQuery.orientation == Orientation.landscape;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Platform.isIOS
          ? _builderCupertionScaffold(isLandscape)
          : _builderMaterialScaffold(isLandscape),
    );
  }
}
