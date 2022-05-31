import 'package:finance2/bloc/account/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/account.dart';
import '../widgets/icon_picker.dart';
import '../widgets/snackbar.dart';

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

  @override
  void initState() {
    if (widget.account != null) {
      isEdit = true;
      title = widget.account!.title;
      icon = widget.account!.icon;
      balance = widget.account!.balance ?? 0;
      description = widget.account!.description;
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
            ? const Text('Create new account')
            : const Text('Edit account'),
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
                    labelText: 'Enter account title',
                    floatingLabelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
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
                        ? 'Account balance'
                        : 'Enter account initial balance',
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
                    labelText: 'Enter account description',
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
                            text: 'Account updated',
                            isPop: true,
                          );
                        } else {
                          //Create new account
                          context
                              .read<AccountBloc>()
                              .add(CreateAccountEvent(newAccount: newAccount));
                          showSnackbar(
                            context,
                            text: 'New account created',
                            isPop: true,
                          );
                        }
                        _formKey.currentState!.reset();
                        Navigator.pop(context);
                      }
                    },
                    child: isEdit
                        ? const Text('Update account')
                        : const Text('Create account'),
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
