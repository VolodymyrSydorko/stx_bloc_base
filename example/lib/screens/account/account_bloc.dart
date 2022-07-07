import 'dart:async';

import 'package:example/helpers/error_handler.dart';
import 'package:example/screens/account/account_repository.dart';
import 'package:example/screens/account/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestState extends NetworkStateBase<Account> {
  final int counter;

  const TestState({
    super.status,
    super.data = const Account(),
    this.counter = 0,
    super.errorMessage,
  });

  @override
  TestState copyWithSuccess(Account data, [int counter = 0]) => copyWith(
        status: NetworkStatus.success,
        data: data,
        counter: counter,
      );

  ///subClassMustOverride
  @override
  TestState copyWith({
    NetworkStatus? status,
    Account? data,
    int? counter,
    String? errorMessage,
  }) {
    return TestState(
      status: status ?? this.status,
      data: data ?? this.data,
      counter: counter ?? this.counter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [...super.props, counter];
}

class NetworkEventCounterAdded extends NetworkEventBase {}

class AccountBloc extends NetworkBlocBase<Account, TestState> {
  AccountBloc({
    required this.repository,
  }) : super(
          TestState(),
          errorHandler: ErrorHandler.parse,
        ) {
    on<NetworkEventCounterAdded>(_counterAdded);
  }

  final AccountRepository repository;

  void increaseCounter() => add(NetworkEventCounterAdded());

  FutureOr<void> _counterAdded(
      NetworkEventCounterAdded event, Emitter<TestState> emit) {
    emit(state.copyWith(counter: state.counter + 1));
  }

  @override
  Future<Account> onLoadDataAsync() {
    return repository.getAccountInfo();
  }
}
