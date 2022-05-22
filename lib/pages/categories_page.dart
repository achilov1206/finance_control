import 'package:finance2/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/blocs.dart';
import '../widgets/error_dialog.dart';
import '../widgets/snackbar.dart';
import './add_edit_category_page.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/category_type_selector.dart.dart';

class CategoriesPage extends StatefulWidget {
  static const String routeName = '/categories-page';
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  //Set to true on [didChangeDependencies] first execute
  bool _init = false;
  //Containt {value: 000, categoryType: CategoryType, account: accountId}
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

  @override
  void didChangeDependencies() {
    if (_init == false) {
      _args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    }
    _init = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    void _onDismissed(key) {
      context.read<CategoryBloc>().add(RemoveCategoryEvent(key: key));
      showSnackbar(context, text: 'Category deleted');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
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
            children: const [Icon(Icons.save), Text('Add Category')],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.categoryStatus == CategoryStatus.loading) {
            return const CircularProgressIndicator();
          } else if (state.categoryStatus == CategoryStatus.error) {
            errorDialog(context, state.error);
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
                  return CustomListTile(
                    iconCodeData: catValue.icon,
                    title: catValue.title!,
                    dataKey: catKey,
                    onTap: () {},
                    onDismissed: () {
                      _onDismissed(catKey);
                    },
                    data: {
                      'subtitle': catValue.description,
                      'trailing': catValue.categoryType.toString(),
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
                  snackBarMessage: 'Category deleted',
                  data: {
                    'subtitle': catValue.description,
                    'trailing': catValue.categoryType == CategoryType.expense
                        ? 'Expense'
                        : 'Income',
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
