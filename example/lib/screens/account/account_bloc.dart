import 'dart:async';

import 'package:example/screens/account/account_repository.dart';
import 'package:example/screens/account/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestState extends NetworkState<Account> {
  final int counter;

  const TestState({
    super.status,
    super.changeReason,
    super.failureReason,
    super.data = const Account(),
    this.counter = 0,
  });

  @override
  TestState copyWithSuccess(
    Account data, {
    int counter = 0,
    DataChangeReason reason = DataChangeReason.none,
  }) =>
      copyWith(
        status: NetworkStatus.success,
        changeReason: reason,
        data: data,
        counter: counter,
      );

  ///subClassMustOverride
  @override
  TestState copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    Account? data,
    int? counter,
  }) {
    return TestState(
      status: status ?? this.status,
      changeReason: changeReason ?? this.changeReason,
      failureReason: failureReason ?? this.failureReason,
      data: data ?? this.data,
      counter: counter ?? this.counter,
    );
  }

  @override
  List<Object?> get props => [...super.props, counter];
}

class NetworkEventCounterAdded extends NetworkEventBase {}

class AccountBloc extends NetworkBloc<Account, TestState> {
  AccountBloc({
    required this.repository,
  }) : super(
          const TestState(),
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
  Future<Account> onLoadAsync() {
    return repository.getAccountInfo();
  }
}
