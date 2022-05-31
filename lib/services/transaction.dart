import 'package:hive/hive.dart';
import 'package:deep_collection/deep_collection.dart';
import '../models/transaction.dart';

class TransactionService {
  late Box<Transaction> _transactions;

  TransactionService() {
    init();
  }

  Future<void> init() async {
    _transactions = Hive.box<Transaction>('transactions');
  }

  Map<dynamic, Transaction> getTransactions() {
    final transactions = _transactions.toMap();
    return transactions.deepReverse();
  }

  Transaction? getTransaction(String key) {
    return _transactions.get(key);
  }

  void addTransaction(Transaction newTransaction) {
    _transactions.add(newTransaction);
  }

  Future<void> removeTransaction(int key) async {
    await _transactions.delete(key);
  }

  Future<void> updateTransaction(int key, Transaction newTransaction) async {
    await _transactions.put(key, newTransaction);
  }
}
