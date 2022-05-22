import 'package:finance2/bloc/account/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_list_tile.dart';
import '../widgets/error_dialog.dart';
import './add_edit_account_page.dart';

class AccountsPage extends StatefulWidget {
  static const String routeName = '/accounts-page';
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  //is floating actinon button visible
  bool _isFABVisible = true;
  final ScrollController _hideFABScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    handleScroll();
  }

  @override
  void dispose() {
    _hideFABScrollController.removeListener(() {});
    super.dispose();
  }

  void showFloationButton() {
    setState(() {
      _isFABVisible = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      _isFABVisible = false;
    });
  }

  //Hide and show floating action button on scroll
  void handleScroll() async {
    _hideFABScrollController.addListener(() {
      if (_hideFABScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (_hideFABScrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: _isFABVisible ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: _isFABVisible
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEditAccountPage(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              : null,
          heroTag: 'addAccountButton',
          label: Row(
            children: const [Icon(Icons.save), Text('Add Account')],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.accountStatus == AccountStatus.loading) {
            return const CircularProgressIndicator();
          } else if (state.accountStatus == AccountStatus.error) {
            errorDialog(context, state.error);
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            //state.accounts type of Map<dynamic, Account>
            controller: _hideFABScrollController,
            itemCount: state.accounts.length,
            itemBuilder: (context, index) {
              final accountKey = state.accounts.keys.elementAt(index);
              final accountValue = state.accounts.values.elementAt(index);
              //if _args null show all categories
              return CustomListTile(
                iconCodeData: accountValue.icon,
                title: accountValue.title!,
                dataKey: accountKey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditAccountPage(
                        account: accountValue,
                        accountKey: accountKey,
                      ),
                    ),
                  );
                },
                onDismissed: () {
                  context.read<AccountBloc>().add(
                        RemoveAccountEvent(key: accountKey),
                      );
                },
                snackBarMessage: 'Account deleted',
                data: {
                  'subtitle': accountValue.description,
                  'trailing': accountValue.balance.toString(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
