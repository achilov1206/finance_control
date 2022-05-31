import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './services/account.dart';
import './services/category.dart';
import './services/transaction.dart';
import './bloc/blocs.dart';
import './pages/app_page.dart';
import './theme/theme.dart';
import './pages/add_transaction_page.dart';
import './pages/enter_amount.dart';
import './pages/categories_page.dart';
import './pages/accounts_page.dart';

import './models/account.dart';
import './models/transaction.dart';
import './models/category.dart';
import './l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  Hive.registerAdapter(AccountAdapter());
  await Hive.openBox<Account>('accounts');
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(CategoryTypeAdapter());
  await Hive.openBox<Category>('categories');
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AccountService()),
        RepositoryProvider(create: (context) => CategoryService()),
        RepositoryProvider(create: (context) => TransactionService()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(context.read<CategoryService>()),
          ),
          BlocProvider<AccountBloc>(
            create: (context) => AccountBloc(context.read<AccountService>()),
          ),
          BlocProvider<TransactionBloc>(
            create: (context) =>
                TransactionBloc(context.read<TransactionService>()),
          ),
        ],
        child: MaterialApp(
          title: 'Finance',
          theme: globalTheme,
          home: const AppPage(),
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: {
            AddTransactionPage.routeName: (ctx) => const AddTransactionPage(),
            EnterAmountPage.routeName: (ctx) => const EnterAmountPage(),
            CategoriesPage.routeName: (ctx) => const CategoriesPage(),
            AccountsPage.routeName: (ctx) => const AccountsPage(),
          },
        ),
      ),
    );
  }
}
