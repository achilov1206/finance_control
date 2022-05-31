import 'package:finance2/services/account.dart';
import 'package:finance2/services/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blocs.dart';
import '../models/account.dart';
import '../widgets/error_dialog.dart';
import './enter_amount.dart';
import '../widgets/custom_expansion_tile.dart';
import '../models/category.dart';

class AddTransactionPage extends StatefulWidget {
  static const routeName = '/add-transaction';
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> accountListTile(
    Map<dynamic, Account> accounts,
    CategoryType catType,
  ) {
    return accounts.entries.map((accountMap) {
      return ListTile(
        title: Text(accountMap.value.title!),
        onTap: () {
          Navigator.of(context).pushNamed(
            EnterAmountPage.routeName,
            arguments: {
              'account': accountMap,
              'categoryType': catType,
            },
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appbar = AppBar(
      title: const Text('New transactions'),
    );
    return Scaffold(
      appBar: appbar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          width: double.infinity,
          height: height - appbar.preferredSize.height - 30,
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              if (state.accountStatus == AccountStatus.loading) {
                return const CircularProgressIndicator();
              } else if (state.accountStatus == AccountStatus.error) {
                Future.delayed(Duration.zero, () {
                  errorDialog(context, state.error);
                });
              }
              return ListView(
                children: [
                  CustomExpansionTile(
                    title: 'Expense',
                    children: accountListTile(
                      state.accounts,
                      CategoryType.expense,
                    ),
                  ),
                  CustomExpansionTile(
                    title: 'Income',
                    children: accountListTile(
                      state.accounts,
                      CategoryType.income,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
