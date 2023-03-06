import 'dart:math';

import 'package:expense/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.onDelete,
  }) : super(key: key);

  final Transaction transaction;
  final Function(String id) onDelete;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  final colors = [
    Colors.orange,
    Colors.green,
    Colors.amber,
    Colors.black,
  ];
  late Color _bgColor;
  @override
  void initState() {
    super.initState();
    _bgColor = colors[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: mediaQuery.size.width > 400
            ? TextButton.icon(
                onPressed: () => widget.onDelete(widget.transaction.id),
                icon: const Icon(
                  Icons.delete,
                ),
                label: const Text('Remove'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).errorColor,
                ),
              )
            : IconButton(
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () => widget.onDelete(widget.transaction.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
