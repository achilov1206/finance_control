part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {}

class CreateTransactionEvent extends TransactionEvent {
  final Transaction newTransaction;
  const CreateTransactionEvent({
    required this.newTransaction,
  });

  @override
  List<Object> get props => [newTransaction];
}

class UpdateTransactionEvent extends TransactionEvent {
  final int key;
  final Transaction newTransaction;
  const UpdateTransactionEvent({
    required this.key,
    required this.newTransaction,
  });

  @override
  List<Object> get props => [key, newTransaction];
}

class RemoveTransactionEvent extends TransactionEvent {
  final int key;
  const RemoveTransactionEvent({
    required this.key,
  });

  @override
  List<Object> get props => [key];
}
