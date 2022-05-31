import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../add_edit_account_page.dart';
import '../app_page.dart';
import '../../bloc/blocs.dart';
import '../../utils/helpers.dart';
import '../../widgets/error_dialog.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final firstSectionHeight = (height / 2) - 50;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: firstSectionHeight,
            child: Card(
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
                      height: firstSectionHeight - 100,
                      child: BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          if (state.transactionStatus ==
                              TransactionStatus.error) {
                            Future.delayed(Duration.zero, () {
                              errorDialog(context, state.error);
                            });
                          } else if (state.transactionStatus ==
                              TransactionStatus.loaded) {
                            if (state.lastTransactions.isEmpty) {
                              return const Center(
                                child: Text("No transactions for today"),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemExtent: 60,
                              itemCount: state.lastTransactions.length,
                              itemBuilder: (ctx, index) {
                                final transactionValue = state
                                    .lastTransactions.values
                                    .elementAt(index);
                                return SizedBox(
                                  height: 200,
                                  child: ListTile(
                                    dense: true,
                                    shape: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    title: Text(
                                      transactionValue.category!.title!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      Helpers.timestampFormatMMMEd(
                                        transactionValue.timestamp!,
                                      ),
                                    ),
                                    trailing: Text(
                                      transactionValue.amount!.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              },
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
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Show more'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppPage(
                                activePageIndex: 1, // TransactionsPage()
                              ),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: height - firstSectionHeight,
              child: BlocBuilder<AccountBloc, AccountState>(
                builder: (context, state) {
                  if (state.accountStatus == AccountStatus.error) {
                    Future.delayed(Duration.zero, () {
                      errorDialog(context, state.error);
                    });
                  } else if (state.accountStatus == AccountStatus.loaded) {
                    return SingleChildScrollView(
                      child: ResponsiveGridRow(
                        children: state.accounts.entries.map((accountMap) {
                          return ResponsiveGridCol(
                            xs: 6,
                            md: 3,
                            child: Container(
                              height: 70,
                              alignment: const Alignment(8, 0),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    accountMap.value.title!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: Icon(
                                    Helpers.retrieveIconFromCodeData(
                                      accountMap.value.icon,
                                    ),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  subtitle: Text(
                                    accountMap.value.balance!
                                        .toStringAsFixed(2),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            AddEditAccountPage(
                                          account: accountMap.value,
                                          accountKey: accountMap.key,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
