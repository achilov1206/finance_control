import 'package:hive/hive.dart';
import '../models/transaction.dart';

class TransactionService {
  late Box<Transaction> _transactions;

  Future<void> init() async {
    Hive.registerAdapter(TransactionAdapter());
    _transactions = await Hive.openBox('transactions');
  }

  List<Transaction> getTransactions() {
    final transactions = _transactions.values.toList();
    return transactions;
  }

  Transaction? getTransaction(String key) {
    return _transactions.get(key);
  }

  void addTransaction(Transaction newTransaction) {
    _transactions.add(newTransaction);
  }

  Future<void> removeTransaction(String key) async {
    await _transactions.delete(key);
  }

  Future<void> updateTransaction(String key, Transaction newTransaction) async {
    final index = int.parse(key);
    await _transactions.put(index, newTransaction);
  }
}
