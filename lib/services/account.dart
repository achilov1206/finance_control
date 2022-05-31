import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/account.dart';
import '../utils/helpers.dart';

class AccountService {
  late Box<Account> _accounts;

  AccountService() {
    init();
  }

  Future<void> init() async {
    _accounts = Hive.box<Account>('accounts');
    if (_accounts.isEmpty) {
      Account card = Account(
        title: 'Card',
        icon: Helpers.iconToCodeData(Icons.credit_card),
        balance: 0,
        description: 'Credit card',
      );
      Account cash = Account(
        title: 'Cash',
        icon: Helpers.iconToCodeData(Icons.money),
        balance: 0,
        description: 'Cash',
      );
      await _accounts.add(card);
      await _accounts.add(cash);
    }
  }

  Map<dynamic, Account> getAccounts() {
    final accounts = _accounts.toMap();
    return accounts;
  }

  Account? getAccount(int key) {
    return _accounts.get(key);
  }

  void addAccount(Account newAccount) async {
    await _accounts.add(newAccount);
  }

  Future<void> removeAccount(int key) async {
    await _accounts.delete(key);
  }

  Future<void> updateAccount(int key, Account newAccount) async {
    await _accounts.put(key, newAccount);
  }

  Future<void> updateAccountBalance(int key, double amount) async {
    Account? account = _accounts.get(key);
    if (account != null) {
      Account newAccount = Account(
        title: account.title,
        icon: account.icon,
        description: account.description,
        balance: account.balance! + amount,
      );
      await _accounts.put(key, newAccount);
    }
  }
}
