part of 'account_bloc.dart';

enum AccountStatus { initial, loading, loaded, error }

class AccountState extends Equatable {
  final Map<dynamic, Account> accounts;
  final AccountStatus accountStatus;
  final CustomError error;
  const AccountState({
    required this.accounts,
    required this.accountStatus,
    required this.error,
  });
  factory AccountState.initial() {
    return const AccountState(
      accounts: {},
      accountStatus: AccountStatus.initial,
      error: CustomError(),
    );
  }
  @override
  List<Object?> get props => [accounts, accountStatus, error];

  @override
  String toString() =>
      'AccountState(accounts: $accounts, accountStatus: $accountStatus, error: $error)';

  AccountState copyWith({
    Map<dynamic, Account>? accounts,
    AccountStatus? accountStatus,
    CustomError? error,
  }) {
    return AccountState(
      accounts: accounts ?? this.accounts,
      accountStatus: accountStatus ?? this.accountStatus,
      error: error ?? this.error,
    );
  }
}
