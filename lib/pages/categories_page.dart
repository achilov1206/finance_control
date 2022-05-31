import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/category.dart';
import '../bloc/blocs.dart';
import '../models/transaction.dart';
import '../widgets/error_dialog.dart';
import '../widgets/snackbar.dart';
import './add_edit_category_page.dart';
import '../widgets/custom_list_tile.dart';
import '../pages/app_page.dart';

class CategoriesPage extends StatefulWidget {
  static const String routeName = '/categories-page';
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  //Set to true on [didChangeDependencies] first execute
  bool _isInit = false;
  //Containt {value: 000, categoryType: CategoryType, account: MapEntry<dynamic, Account>,}
  Map<String, dynamic>? _args;

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

  void confirmTransactionDialog(Transaction transaction, int accountKey) {
    final _formKey = GlobalKey<FormState>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        String? description;
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.add_new_transaction,
            style: const TextStyle(fontSize: 16),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                        "[0-9a-zA-Z /-?!#&%()]",
                      )),
                    ],
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: AppLocalizations.of(context)!
                          .enter_transaction_description,
                      floatingLabelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    autofocus: true,
                    onSaved: (value) {
                      description = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _formKey.currentState!.save();
                FocusScope.of(context).requestFocus(FocusNode());
                Transaction newTransaction = Transaction(
                  category: transaction.category,
                  account: transaction.account,
                  amount: transaction.amount,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                  description: description,
                  accountKey: transaction.accountKey,
                  categoryKey: transaction.categoryKey,
                );
                showSnackbar(
                  context,
                  text:
                      AppLocalizations.of(context)!.snackbar_transaction_added,
                  isPop: false,
                );
                //add new transaction
                context.read<TransactionBloc>().add(
                      CreateTransactionEvent(newTransaction: newTransaction),
                    );
                //update category balance
                context.read<AccountBloc>().add(
                      UpdateAccountBalanceEvent(
                        key: accountKey,
                        amount: transaction.amount!,
                      ),
                    );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppPage(
                      activePageIndex: 1,
                    ),
                  ),
                  (route) => false,
                );
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit == false) {
      _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    void _onDismissed(key) {
      context.read<CategoryBloc>().add(RemoveCategoryEvent(key: key));
      showSnackbar(
        context,
        text: AppLocalizations.of(context)!.category_deleted,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.category),
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
                      builder: (context) => const AddEditCategoryPage(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              : null,
          heroTag: 'addCategoryButton',
          label: Row(
            children: [
              const Icon(Icons.save),
              Text(AppLocalizations.of(context)!.add_category),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.categoryStatus == CategoryStatus.loading) {
            return const CircularProgressIndicator();
          } else if (state.categoryStatus == CategoryStatus.error) {
            Future.delayed(Duration.zero, () {
              errorDialog(context, state.error);
            });
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            //state.categories type of Map<dynamic, Category
            controller: _hideFABScrollController,
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final catKey = state.categories.keys.elementAt(index);
              final catValue = state.categories.values.elementAt(index);
              if (_args != null) {
                //Only show categories where category type == args category type
                if (catValue.categoryType == _args!['categoryType']) {
                  double amount = _args!['amount'];
                  //if exepense amount negative value
                  if (_args!['categoryType'] == CategoryType.expense) {
                    amount *= -1;
                  }
                  return CustomListTile(
                    iconCodeData: catValue.icon,
                    title: catValue.title!,
                    dataKey: catKey,
                    onTap: () {
                      Transaction transaction = Transaction(
                        category: catValue,
                        account: _args!['account'].value,
                        amount: amount,
                        accountKey: _args!['account'].key,
                        categoryKey: catKey,
                      );
                      confirmTransactionDialog(
                        transaction,
                        _args!['account'].key,
                      );
                    },
                    onDismissed: () {
                      _onDismissed(catKey);
                    },
                    data: {
                      'subtitle': catValue.description,
                      'trailing': Category.getCategoryString(
                        catValue.categoryType!,
                        context,
                      ),
                    },
                  );
                }
                return const SizedBox();
              } else {
                //if _args null show all categories
                return CustomListTile(
                  iconCodeData: catValue.icon,
                  title: catValue.title!,
                  dataKey: catKey,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditCategoryPage(
                          cat: catValue,
                          catKey: catKey,
                        ),
                      ),
                    );
                  },
                  onDismissed: () {
                    _onDismissed(catKey);
                  },
                  snackBarMessage:
                      AppLocalizations.of(context)!.category_deleted,
                  data: {
                    'subtitle': catValue.description,
                    'trailing': catValue.categoryType == CategoryType.expense
                        ? AppLocalizations.of(context)!.expense
                        : AppLocalizations.of(context)!.income,
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
