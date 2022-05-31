import 'package:flutter/material.dart';

import './home/todays_page.dart';
import './home/month_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OverView'),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Colors.white,
              child: TabBar(
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Text(
                    'TODAY',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'THIS MONTH',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
                onTap: (index) {},
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [
          TodayPage(),
          MonthPage(),
        ]),
      ),
    );
  }
}
