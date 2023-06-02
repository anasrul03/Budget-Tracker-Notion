import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'budget_repo.dart';
import 'failure_model.dart';
import 'items_model.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Future<List<Item>> _futureItems;
  @override
  void initState() {
    super.initState();
    _futureItems = BudgetRepo().getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _futureItems = BudgetRepo().getItems();
          setState(() {});
        },
        child: FutureBuilder<List<Item>>(
            future: _futureItems,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = items[index];
                    return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0)
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 1.6, color: getStatus(item.isPaid)),
                            color: Colors.white),
                        child: ListTile(
                          // leading: IconButton(
                          //   icon: const Icon(Icons.done_rounded),
                          //   onPressed: () {},
                          // ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          subtitle: Text(
                            DateFormat('EEEE, d MMM yyyy').format(item.date),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black45),
                          ),
                          trailing: Text(
                            'RM${item.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                final failure = snapshot.error as Failure;
                return Center(child: Text(failure.message));
              }

              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

Color getStatus(bool isPaid) {
  switch (isPaid) {
    case true:
      return Colors.greenAccent;
    case false:
      return Colors.redAccent;
    default:
      return Colors.grey;
  }
}
