import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/blocs.dart';
import '../models/category.dart';
import '../utils/helpers.dart';
import '../widgets/snackbar.dart';
import '../models/transaction.dart';
import './dialog_with_checkbox.dart';

class TransactionListTile extends StatelessWidget {
  final int transactionKey;
  final Transaction transactionValue;
  const TransactionListTile({
    Key? key,
    required this.transactionValue,
    required this.transactionKey,
  }) : super(key: key);

  Widget showBackground(int direction) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red.withOpacity(0.2),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        size: 30,
        color: Colors.white,
      ),
    );
  }

  Widget accountBalanceText(double amount, CategoryType catType) {
    String balance;
    if (catType == CategoryType.income) {
      balance = '+${amount.toStringAsFixed(2)}';
    } else {
      balance = amount.toStringAsFixed(2);
    }
    return Text(balance);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Dismissible(
        key: ValueKey('transaction-$transactionKey'),
        background: showBackground(0),
        secondaryBackground: showBackground(1),
        child: ListTile(
          tileColor: Colors.white,
          leading: Icon(
            transactionValue.category!.categoryType == CategoryType.income
                ? Icons.add_circle
                : Icons.remove_circle,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            transactionValue.category!.title!,
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Helpers.dateFormatJm(transactionValue.timestamp!, context),
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
              Text(
                '${transactionValue.description}',
                overflow: TextOverflow.clip,
                softWrap: true,
              ),
            ],
          ),
          trailing: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                accountBalanceText(
                  transactionValue.amount!,
                  transactionValue.category!.categoryType!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Helpers.retrieveIconFromCodeData(
                        transactionValue.account!.icon,
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      transactionValue.account!.title!,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onDismissed: (_) async {
          context.read<TransactionBloc>().add(
                RemoveTransactionEvent(key: transactionKey),
              );
          showSnackbar(
            context,
            text: AppLocalizations.of(context)!.transaction_deleted,
          );
        },
        confirmDismiss: (_) {
          return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return DialogWithCheckbox(
                title: AppLocalizations.of(context)!.del_confirm2,
                checkboxText: AppLocalizations.of(context)!.transaction_restore,
                beforeDelete: () {
                  //restore the transaction amount to the card balance if checked
                  double amount = transactionValue.amount! * -1;
                  context.read<AccountBloc>().add(UpdateAccountBalanceEvent(
                        key: transactionValue.accountKey!,
                        amount: amount,
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
