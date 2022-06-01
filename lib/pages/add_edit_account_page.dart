import 'package:finance2/bloc/account/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/account.dart';
import '../widgets/icon_picker.dart';
import '../widgets/snackbar.dart';
import '../widgets/currency_picker.dart';

class AddEditAccountPage extends StatefulWidget {
  //Account not null if edit
  final Account? account;
  final int? accountKey;
  const AddEditAccountPage({
    Key? key,
    this.account,
    this.accountKey,
  }) : super(key: key);

  @override
  State<AddEditAccountPage> createState() => _AddEditAccountPageState();
}

class _AddEditAccountPageState extends State<AddEditAccountPage> {
  final _formKey = GlobalKey<FormState>();
  //if true edit account
  //else create new account
  bool isEdit = false;
  String? title;
  Map<String, dynamic>? icon;
  double? balance;
  String? description;
  String? currencySymbol;

  @override
  void initState() {
    if (widget.account != null) {
      isEdit = true;
      title = widget.account!.title;
      icon = widget.account!.icon;
      balance = widget.account!.balance ?? 0;
      description = widget.account!.description;
      currencySymbol = widget.account!.currencyCode;
    } else {
      balance = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit
            ? Text(AppLocalizations.of(context)!.edit_account)
            : Text(AppLocalizations.of(context)!.create_new_account),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //Account title field
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
                        AppLocalizations.of(context)!.enter_account_title,
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

                //Account Icon field
                IconPicker(
                  iconCodeData: icon,
                  onSelect: (Map<String, dynamic> selectedIcon) {
                    icon = selectedIcon;
                  },
                ),
                //Account initial balance field
                TextFormField(
                  readOnly: isEdit,
                  keyboardType: TextInputType.number,
                  initialValue: balance!.toStringAsFixed(2),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: isEdit
                        ? AppLocalizations.of(context)!.account_balance
                        : AppLocalizations.of(context)!
                            .enter_account_initial_balance,
                    floatingLabelStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    //Select currency
                    suffix: CurrencyPicker(
                      onCurrencySelected: (String symbol) {
                        currencySymbol = symbol;
                      },
                      currencySymbol: currencySymbol,
                    ),
                  ),
                  onSaved: (value) {
                    balance = double.parse(value ?? '0');
                  },
                ),
                //Account Description field
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
                    labelText:
                        AppLocalizations.of(context)!.enter_account_description,
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
                    description = value ?? '';
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
                        Account newAccount = Account(
                          title: title,
                          icon: icon,
                          balance: balance,
                          description: description,
                          currencyCode: currencySymbol,
                        );
                        if (isEdit) {
                          //Update account by key
                          context.read<AccountBloc>().add(
                                UpdateAccountEvent(
                                  key: widget.accountKey!,
                                  newAccount: newAccount,
                                ),
                              );
                          showSnackbar(
                            context,
                            text: AppLocalizations.of(context)!
                                .snackbar_account_updated,
                            isPop: true,
                          );
                        } else {
                          //Create new account
                          context
                              .read<AccountBloc>()
                              .add(CreateAccountEvent(newAccount: newAccount));
                          showSnackbar(
                            context,
                            text: AppLocalizations.of(context)!
                                .snackbar_account_created,
                            isPop: true,
                          );
                        }
                        _formKey.currentState!.reset();
                        Navigator.pop(context);
                      }
                    },
                    child: isEdit
                        ? Text(AppLocalizations.of(context)!.update_account)
                        : Text(AppLocalizations.of(context)!.create_account),
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
