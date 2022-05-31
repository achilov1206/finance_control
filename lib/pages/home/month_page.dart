import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../bloc/blocs.dart';
import '../../widgets/custom_piechart.dart';
import '../../widgets/error_dialog.dart';

class MonthPage extends StatelessWidget {
  const MonthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state.transactionStatus == TransactionStatus.error) {
          Future.delayed(Duration.zero, () {
            errorDialog(context, state.error);
          });
        } else if (state.transactionStatus == TransactionStatus.loaded) {
          var totalAmountByCategories = state.totalAmountByCategories(
            startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
            endDate: DateTime.now(),
          );
          double _totalExpanses = 0;
          double _totalIncomes = 0;
          totalAmountByCategories.forEach((key, value) {
            _totalExpanses += value.expense!;
            _totalIncomes += value.income!;
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomPieChart(
                    categoryTotalAmountData:
                        totalAmountByCategories.values.toList(),
                  ),
                  const SizedBox(height: 10),
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
                                title: Text(
                                    AppLocalizations.of(context)!.expenses),
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
                                title:
                                    Text(AppLocalizations.of(context)!.incomes),
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
              ),
            ),
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
    );
  }
}
