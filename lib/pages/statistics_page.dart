import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './statistics/expenses_page.dart';
import './statistics/incomes_page.dart';
import './statistics/summory_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.statistics),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Text(
                    AppLocalizations.of(context)!.expenses.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    AppLocalizations.of(context)!.incomes.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    AppLocalizations.of(context)!.summory.toUpperCase(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Text(
                  //   'CATEGORIES',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                ],
                onTap: (index) {},
              ),
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TabBarView(children: [
            ExpensesPage(),
            IncomesPage(),
            SummoryPage(),
            // CategoriesPage(),
          ]),
        ),
      ),
    );
  }
}
