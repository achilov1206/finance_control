import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './accounts_page.dart';
import './categories_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            //Categories
            InkWell(
              splashColor: Colors.grey,
              highlightColor: Colors.grey,
              onTap: () {
                Navigator.pushNamed(context, CategoriesPage.routeName);
              },
              child: Ink(
                color: Colors.white,
                child: ListTile(
                  style: ListTileStyle.list,
                  onTap: null,
                  leading: Icon(
                    Icons.grid_4x4,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(AppLocalizations.of(context)!.categories),
                  subtitle: Text(AppLocalizations.of(context)!.manage_category),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //Accounts
            InkWell(
              splashColor: Colors.grey,
              highlightColor: Colors.grey,
              onTap: () {
                Navigator.pushNamed(context, AccountsPage.routeName);
              },
              child: Ink(
                color: Colors.white,
                child: ListTile(
                  style: ListTileStyle.list,
                  onTap: null,
                  leading: Icon(
                    Icons.grid_4x4,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(AppLocalizations.of(context)!.accounts),
                  subtitle: Text(AppLocalizations.of(context)!.manage_account),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
