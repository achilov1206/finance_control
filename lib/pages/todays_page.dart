import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  List<Map<String, dynamic>> transactions = [
    {
      'category': 'Home',
      'amount': -200000,
      'datetime': DateTime.now(),
    },
    {
      'category': 'Car',
      'amount': -150000,
      'datetime': DateTime.now(),
    },
    {
      'category': 'Job',
      'amount': -250000,
      'datetime': DateTime.now(),
    },
    {
      'category': 'Eat',
      'amount': -150000,
      'datetime': DateTime.now(),
    },
  ];

  List<Map<String, dynamic>> account = [
    {'title': 'Cash', 'balance': 3000000},
    {'title': 'Card', 'balance': 2000000},
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final firstSectionHeight = height / 3;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: firstSectionHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemExtent: 60,
                        itemCount: transactions.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            dense: true,
                            shape: Border(
                              bottom: BorderSide(
                                  width: 1, color: Colors.grey[300]!),
                            ),
                            title: Text(
                              transactions[index]['category'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              DateFormat.MMMEd().format(
                                transactions[index]['datetime'],
                              ),
                            ),
                            trailing: Text(
                              transactions[index]['amount'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            onTap: () {},
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Show more'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height - firstSectionHeight,
              child: GridView.builder(
                itemCount: account.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (ctx, index) {
                  return GridTile(
                    child: Card(
                      child: Text(account[index]['title']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
