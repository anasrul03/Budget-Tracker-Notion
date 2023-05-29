import 'package:budget_tracker/budget_repo.dart';
import 'package:budget_tracker/failure_model.dart';
import 'package:budget_tracker/items_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BudgetScreen(),
    );
  }
}

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
        title: Text('Budget Tracker'),
      ),
      body: FutureBuilder<List<Item>>(
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
                          color: Colors.white),
                      child: ListTile(
                        title: Text(item.name),
                      ));
                },
              );
            } else if (snapshot.hasError) {
              final failure = snapshot.error as Failure;
              return Center(child: Text(failure.message));
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
