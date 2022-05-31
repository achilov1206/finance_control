import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category.dart';
import '../../widgets/custom_piechart.dart';
import '../../bloc/blocs.dart';
import '../../widgets/date_range_selector.dart';
import '../../widgets/error_dialog.dart';

class IncomesPage extends StatefulWidget {
  const IncomesPage({Key? key}) : super(key: key);

  @override
  State<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
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
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state.transactionStatus == TransactionStatus.error) {
          Future.delayed(Duration.zero, () {
            errorDialog(context, state.error);
          });
        } else if (state.transactionStatus == TransactionStatus.loaded) {
          var totalAmountByCategories = state.totalAmountByCategoryType(
            startDate: _startDate!,
            endDate: _endDate!,
            catType: CategoryType.income,
          );
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
                CustomPieChart(
                  categoryTotalAmountData:
                      totalAmountByCategories.values.toList(),
                ),
              ],
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
