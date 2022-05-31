import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/blocs.dart';
import './add_transaction_page.dart';
import './home_page.dart';
import './settings_page.dart';
import './statistics_page.dart';
import './transactions_page.dart';

class AppPage extends StatefulWidget {
  final int? activePageIndex;
  const AppPage({
    Key? key,
    this.activePageIndex,
  }) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int _activePageIndex = 0;
  @override
  void initState() {
    if (widget.activePageIndex != null) {
      _activePageIndex = widget.activePageIndex!;
    }
    super.initState();
  }

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
    //Load All Data
    context.read<AccountBloc>().add(LoadAccountsEvent());
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    context.read<TransactionBloc>().add(LoadTransactionsEvent());

    return Scaffold(
      body: IndexedStack(
        children: _pages,
        index: _activePageIndex,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).primaryColor,
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
        backgroundColor: Theme.of(context).primaryColor,
        heroTag: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
