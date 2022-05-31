import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_bloc/flutter_bloc.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

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
