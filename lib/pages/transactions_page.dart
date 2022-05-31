import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/blocs.dart';
import '../widgets/error_dialog.dart';
import '../widgets/transaction_list_tile.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  //Separator for Tasks list with date label
  Widget listSectionSeparator(DateTime dateLabel, double amount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.MMMEd().format(dateLabel),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            amount.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactions),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state.transactionStatus == TransactionStatus.error) {
              Future.delayed(Duration.zero, () {
                errorDialog(context, state.error);
              });
            } else if (state.transactionStatus == TransactionStatus.loaded) {
              List<Widget> _widgetList = [];
              List<Widget> _transactionListTile = [];
              double dailyAmount = 0;
              state.transactionsData.forEach((dateTime, transactionMap) {
                for (Map transaction in transactionMap) {
                  dailyAmount += transaction.entries.first.value.amount;
                  _transactionListTile.add(TransactionListTile(
                    transactionValue: transaction.entries.first.value,
                    transactionKey: transaction.entries.first.key,
                  ));
                }
                _widgetList.add(listSectionSeparator(dateTime, dailyAmount));
                _widgetList.addAll(_transactionListTile);
                dailyAmount = 0;
              });
              return ListView(
                shrinkWrap: true,
                children: _widgetList,
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
      ),
    );
  }
}
