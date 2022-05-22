import 'package:finance2/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './home_page.dart';
import './transactions_page.dart';
import './statistics_page.dart';
import './settings_page.dart';
import './add_transaction_page.dart';

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  void initState() {
    super.initState();

    //Register Hive database
    //BlocProvider.of<InitBloc>(context).add(RegisterServiceEvent());
    //Get all accounts
    //BlocProvider.of<AccountBloc>(context).add(LoadAccountsEvent());
  }

  @override
  void dispose() {
    print('App page disposed');
    super.dispose();
  }

  var _activePageIndex = 0;
  _selectedPage(index) {
    setState(() {
      _activePageIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const TransactionsPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    //Load accounts
    context.read<AccountBloc>().add(LoadAccountsEvent());
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    return Scaffold(
      body: IndexedStack(
        children: _pages,
        index: _activePageIndex,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Theme.of(context).primaryColor,
        splashColor: Colors.pink[200],
        inactiveColor: Colors.black.withOpacity(0.5),
        icons: const [
          Icons.home,
          Icons.list,
          Icons.bar_chart,
          Icons.settings,
        ],
        activeIndex: _activePageIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 10,
        iconSize: 30,
        rightCornerRadius: 10,
        onTap: (index) {
          _selectedPage(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddTransactionPage.routeName);
        },
        child: const Icon(
          Icons.add,
          size: 25,
        ),
        backgroundColor: Colors.pink,
        heroTag: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
