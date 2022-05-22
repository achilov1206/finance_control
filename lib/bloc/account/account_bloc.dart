import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

import '../../models/account.dart';
import '../../models/custom_error.dart';
import '../../services/account.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountService _accountService;
  AccountBloc(
    this._accountService,
  ) : super(AccountState.initial()) {
    on<LoadAccountsEvent>((event, emit) {
      print('Account event');
      emit(state.copyWith(accountStatus: AccountStatus.loading));
      try {
        Map<dynamic, Account> accounts = _accountService.getAccounts();
        emit(state.copyWith(
          accounts: accounts,
          accountStatus: AccountStatus.loaded,
        ));
      } catch (e) {
        emit(
          state.copyWith(
            accountStatus: AccountStatus.error,
            error: CustomError(
              message: e.toString(),
              plugin: 'accountBloc/LoadAccountsEvent',
            ),
          ),
        );
      }
    });
    on<CreateAccountEvent>((event, emit) {
      try {
        _accountService.addAccount(event.newAccount);
        add(LoadAccountsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<UpdateAccountEvent>((event, emit) {
      try {
        _accountService.updateAccount(event.key, event.newAccount);
        add(LoadAccountsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
    on<RemoveAccountEvent>((event, emit) {
      try {
        _accountService.removeAccount(event.key);
        add(LoadAccountsEvent());
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
