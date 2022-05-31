import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/category_total_amount.dart';
import '../../models/category.dart';
import '../../models/transaction.dart';
import '../../models/custom_error.dart';
import '../../services/transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService;
  TransactionBloc(this._transactionService)
      : super(TransactionState.initial()) {
    on<LoadTransactionsEvent>((event, emit) {
      emit(state.copyWith(transactionStatus: TransactionStatus.loading));
      try {
        Map<dynamic, Transaction> transactions =
            _transactionService.getTransactions();
        emit(state.copyWith(
          transactions: transactions,
          transactionStatus: TransactionStatus.loaded,
        ));
      } catch (e) {
        emit(
          state.copyWith(
            transactionStatus: TransactionStatus.error,
            error: CustomError(
              message: e.toString(),
              plugin: 'transactionBloc/LoadTransactionsEvent',
            ),
          ),
        );
      }
    });
    on<CreateTransactionEvent>((event, emit) {
      try {
        _transactionService.addTransaction(event.newTransaction);
        add(LoadTransactionsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<UpdateTransactionEvent>((event, emit) {
      try {
        _transactionService.updateTransaction(event.key, event.newTransaction);
        add(LoadTransactionsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<RemoveTransactionEvent>((event, emit) {
      try {
        _transactionService.removeTransaction(event.key);
        add(LoadTransactionsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
