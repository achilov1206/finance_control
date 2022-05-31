import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/blocs.dart';
import '../models/category.dart';
import '../widgets/snackbar.dart';
import '../widgets/icon_picker.dart';
import '../widgets/category_type_selector.dart.dart';

class AddEditCategoryPage extends StatefulWidget {
  //Category not null if edit
  final Category? cat;
  //Category key id, need provide only on edit mode
  final int? catKey;
  //Category type, if edit mode no need provide
  final CategoryType? catType;
  const AddEditCategoryPage({
    Key? key,
    this.cat,
    this.catType,
    this.catKey,
  }) : super(key: key);

  @override
  State<AddEditCategoryPage> createState() => _AddEditCategoryPageState();
}

class _AddEditCategoryPageState extends State<AddEditCategoryPage> {
  final _formKey = GlobalKey<FormState>();
  //if true edit category
  //else create new category
  bool edit = false;
  String? title;
  //Code Date of icon
  Map<String, dynamic>? icon;
  String? description;
  CategoryType? categoryType;

  @override
  void initState() {
    if (widget.cat != null) {
      edit = true;
      title = widget.cat!.title;
      icon = widget.cat!.icon;
      description = widget.cat!.description;
      categoryType = widget.cat!.categoryType;
    } else {
      categoryType = widget.catType ?? CategoryType.expense;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: edit
            ? Text(AppLocalizations.of(context)!.create_new_category)
            : Text(AppLocalizations.of(context)!.edit_category),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Category title field
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                      "[0-9a-zA-Z /-?!#&%()]",
                    )),
                  ],
                  initialValue: title ?? '',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText:
                        AppLocalizations.of(context)!.enter_category_title,
                    floatingLabelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.please_enter_title;
                    }
                    return null;
                  },
                  onSaved: (value) {
                    title = value;
                  },
                ),
                const SizedBox(height: 10),

                //Category Icon field
                IconPicker(
                  iconCodeData: icon,
                  onSelect: (Map<String, dynamic> selectedIcon) {
                    icon = selectedIcon;
                  },
                ),
                //Select Category Type
                CategoryTypeSelector(
                  dropdownHint:
                      AppLocalizations.of(context)!.select_category_type,
                  onValueChanged: (CategoryType catType) {
                    categoryType = catType;
                  },
                  defaultValue: categoryType!,
                ),

                //Category Description field
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                      "[0-9a-zA-Z /-?!#&%()]",
                    )),
                  ],
                  initialValue: description ?? '',
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: AppLocalizations.of(context)!
                        .enter_category_description,
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  onSaved: (value) {
                    description = value ?? "";
                  },
                ),
                const SizedBox(height: 30),
                //Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        FocusScope.of(context).requestFocus(FocusNode());
                        Category newCategory = Category(
                          title: title,
                          icon: icon,
                          description: description,
                          categoryType: categoryType!,
                        );
                        if (edit) {
                          //Update category by key
                          context.read<CategoryBloc>().add(
                                UpdateCategoryEvent(
                                  key: widget.catKey!,
                                  newCategory: newCategory,
                                ),
                              );
                          showSnackbar(context,
                              text: AppLocalizations.of(context)!
                                  .snackbar_category_updated);
                        } else {
                          //Create new category
                          context.read<CategoryBloc>().add(
                              CreateCategoryEvent(newCategory: newCategory));
                          showSnackbar(
                            context,
                            text: AppLocalizations.of(context)!
                                .snackbar_category_created,
                          );
                        }
                        _formKey.currentState!.reset();
                        Navigator.pop(context);
                      }
                    },
                    child: edit
                        ? Text(AppLocalizations.of(context)!.update_category)
                        : Text(AppLocalizations.of(context)!.create_category),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
