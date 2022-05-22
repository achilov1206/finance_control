import 'package:hive/hive.dart';

import '../models/account.dart';

class AccountService {
  late Box<Account> _accounts;
  AccountService() {
    init();
  }

  Future<void> init() async {
    Hive.registerAdapter(AccountAdapter());
    _accounts = await Hive.openBox<Account>('accounts');
  }

  Map<dynamic, Account> getAccounts() {
    final accounts = _accounts.toMap();
    return accounts;
  }

  Account? getAccount(int key) {
    return _accounts.get(key);
  }

  void addAccount(Account newAccount) {
    _accounts.add(newAccount);
  }

  Future<void> removeAccount(int key) async {
    await _accounts.delete(key);
  }

  Future<void> updateAccount(int key, Account newAccount) async {
    final index = key;
    await _accounts.put(index, newAccount);
  }
}
