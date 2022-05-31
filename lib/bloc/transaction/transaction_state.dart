part of 'transaction_bloc.dart';

enum TransactionStatus { initial, loading, loaded, error }

class TransactionState extends Equatable {
  final Map<dynamic, Transaction> transactions;
  final TransactionStatus transactionStatus;
  final CustomError error;
  const TransactionState({
    required this.transactions,
    required this.transactionStatus,
    required this.error,
  });

  Map<dynamic, Transaction> get lastTransactions {
    int last24Hours =
        DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;
    Map<dynamic, Transaction> lastTransactions = {};
    transactions.forEach((key, value) {
      if (value.timestamp! >= last24Hours) {
        lastTransactions.addAll({key: value});
      }
    });
    return lastTransactions;
  }

  Map<Category, CategoryTotalAmount> totalAmountByCategories({
    required DateTime startDate,
    required DateTime endDate,
    CategoryType? catType,
  }) {
    Map<Category, CategoryTotalAmount> td = {};
    transactions.forEach((key, transaction) {
      double expense = 0;
      double income = 0;
      if (transaction.category!.categoryType == CategoryType.expense) {
        expense = transaction.amount!;
      } else {
        income = transaction.amount!;
      }
      if (transaction.timestamp! >= startDate.millisecondsSinceEpoch &&
          transaction.timestamp! <= endDate.millisecondsSinceEpoch) {
        if (td.containsKey(transaction.category)) {
          CategoryTotalAmount _newCatTotalAmount = CategoryTotalAmount(
            category: transaction.category,
            numberOfTransactions:
                td[transaction.category]!.numberOfTransactions! + 1,
            totalAmount: td[transaction.category]!.totalAmount!.abs() +
                transaction.amount!.abs(),
            expense: td[transaction.category]!.expense! + expense,
            income: td[transaction.category]!.income! + income,
          );

          td[transaction.category!] = _newCatTotalAmount;
        } else {
          td.addAll({
            transaction.category!: CategoryTotalAmount(
              category: transaction.category,
              numberOfTransactions: 1,
              expense: expense,
              income: income,
              totalAmount: transaction.amount!.abs(),
            )
          });
        }
      }
    });
    return td;
  }

  Map<Category, CategoryTotalAmount> totalAmountByCategoryType({
    required DateTime startDate,
    required DateTime endDate,
    required CategoryType catType,
  }) {
    Map<Category, CategoryTotalAmount> td = {};
    transactions.forEach((key, transaction) {
      double expense = 0;
      double income = 0;
      if (transaction.category!.categoryType == CategoryType.expense) {
        expense = transaction.amount!;
      } else {
        income = transaction.amount!;
      }
      if (transaction.category!.categoryType == catType &&
          transaction.timestamp! >= startDate.millisecondsSinceEpoch &&
          transaction.timestamp! <= endDate.millisecondsSinceEpoch) {
        if (td.containsKey(transaction.category)) {
          CategoryTotalAmount _newCatTotalAmount = CategoryTotalAmount(
            category: transaction.category,
            numberOfTransactions:
                td[transaction.category]!.numberOfTransactions! + 1,
            totalAmount: td[transaction.category]!.totalAmount!.abs() +
                transaction.amount!.abs(),
            expense: td[transaction.category]!.expense! + expense,
            income: td[transaction.category]!.income! + income,
          );

          td[transaction.category!] = _newCatTotalAmount;
        } else {
          td.addAll({
            transaction.category!: CategoryTotalAmount(
              category: transaction.category,
              numberOfTransactions: 1,
              expense: expense,
              income: income,
              totalAmount: transaction.amount!.abs(),
            )
          });
        }
      }
    });
    return td;
  }

  //return transactions sorted by DateTime and with total transactions amount
  Map<DateTime, List<Map<dynamic, Transaction>>> get transactionsData {
    Map<DateTime, List<Map<dynamic, Transaction>>> td = {};
    if (transactions.isNotEmpty) {
      DateTime dateLabel;
      transactions.forEach((key, transaction) {
        DateTime transactionDT =
            DateTime.fromMillisecondsSinceEpoch(transaction.timestamp!);
        dateLabel = DateTime(
          transactionDT.year,
          transactionDT.month,
          transactionDT.day,
        );
        if (td.containsKey(dateLabel)) {
          td[dateLabel]!.add({key: transaction});
        } else {
          td.addAll({
            dateLabel: [
              {key: transaction}
            ]
          });
        }
      });
    }
    return td;
  }

  factory TransactionState.initial() {
    return const TransactionState(
      transactions: {},
      transactionStatus: TransactionStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object?> get props => [transactions, transactionStatus];

  TransactionState copyWith({
    Map<dynamic, Transaction>? transactions,
    TransactionStatus? transactionStatus,
    CustomError? error,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'TransactionState(transactions: $transactions, transactionStatus: $transactionStatus, eror: $error)';
}
