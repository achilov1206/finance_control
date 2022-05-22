import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/account.dart';
import '../../services/category.dart';
import '../../services/transaction.dart';

part 'init_event.dart';
part 'init_state.dart';

class InitBloc extends Bloc<InitEvent, InitState> {
  final AccountService accountService;
  final CategoryService categoryService;
  final TransactionService transactionService;
  InitBloc({
    required this.accountService,
    required this.categoryService,
    required this.transactionService,
  }) : super(InitState.initial()) {
    on<RegisterServiceEvent>((event, emit) async {
      print('Init Event');
      await categoryService.init();
      await accountService.init();
      await transactionService.init();
    });
  }
}
