import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blocs.dart';
import '../../widgets/date_range_selector.dart';
import '../../widgets/error_dialog.dart';

class SummoryPage extends StatefulWidget {
  const SummoryPage({Key? key}) : super(key: key);

  @override
  State<SummoryPage> createState() => _SummoryPageState();
}

class _SummoryPageState extends State<SummoryPage> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    _startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    _endDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DateRangeSelector(
            startDate: _startDate!,
            endDate: _endDate!,
            onDateSelected: (DateTime startDate, DateTime endDate) {
              setState(() {
                _startDate = startDate;
                _endDate = endDate;
              });
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state.transactionStatus == TransactionStatus.error) {
                Future.delayed(Duration.zero, () {
                  errorDialog(context, state.error);
                });
              } else if (state.transactionStatus == TransactionStatus.loaded) {
                var totalAmountByCategories = state.totalAmountByCategories(
                  startDate: _startDate!,
                  endDate: _endDate!,
                );
                double _totalExpanses = 0;
                double _totalIncomes = 0;
                totalAmountByCategories.forEach((key, value) {
                  _totalExpanses += value.expense!;
                  _totalIncomes += value.income!;
                });
                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.remove_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: const Text('Expanses'),
                                  trailing: Text(
                                    _totalExpanses.toStringAsFixed(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.add_circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  title: const Text('Incomes'),
                                  trailing: Text(
                                    _totalIncomes.toStringAsFixed(2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
