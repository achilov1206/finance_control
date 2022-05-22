part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountsEvent extends AccountEvent {}

class CreateAccountEvent extends AccountEvent {
  final Account newAccount;
  const CreateAccountEvent({
    required this.newAccount,
  });

  @override
  List<Object> get props => [newAccount];
}

class UpdateAccountEvent extends AccountEvent {
  final int key;
  final Account newAccount;
  const UpdateAccountEvent({
    required this.key,
    required this.newAccount,
  });

  @override
  List<Object> get props => [key, newAccount];
}

class RemoveAccountEvent extends AccountEvent {
  final int key;
  const RemoveAccountEvent({
    required this.key,
  });

  @override
  List<Object> get props => [key];
}
