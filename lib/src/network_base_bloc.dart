import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models.dart';
import 'network_base_bloc_event.dart';

class NetworkStateBase<T> extends Equatable {
  final NetworkStatus status;
  final T data;
  final String? errorMessage;

  const NetworkStateBase({
    this.status = NetworkStatus.initial,
    required this.data,
    this.errorMessage,
  });

  ///subClassMustOverride
  NetworkStateBase<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  ///subClassMustOverride
  NetworkStateBase<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data);

  ///subClassMustOverride
  NetworkStateBase<T> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  ///subClassMustOverride
  NetworkStateBase<T> copyWith({
    NetworkStatus? status,
    T? data,
    String? errorMessage,
  }) {
    return NetworkStateBase(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get errorMsg => errorMessage ?? 'Something went wrong';

  @override
  List<Object?> get props => [status, data, errorMessage];
}

abstract class NetworkBlocBase<T, S extends NetworkStateBase<T>>
    extends Bloc<NetworkEventBase, S> {
  NetworkBlocBase(
    super.initialState, {
    this.errorHandler,
  }) {
    on<NetworkEventLoad>(onEventLoad);
    on<NetworkEventUpdate>(onEventUpdate);
    on<NetworkEventUpdateAsync>(onEventUpdateAsync);
  }

  final String? Function(Object, StackTrace)? errorHandler;

  void load() => add(NetworkEventLoad());

  void update(T updatedData) => add(NetworkEventUpdate(updatedData));
  void updateAsync(T updatedData) => add(NetworkEventUpdateAsync(updatedData));

  FutureOr<void> onEventLoad(
      NetworkEventLoad event, Emitter<NetworkStateBase<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var data = await onLoadDataAsync();

      emit(onStateChanged(event, state.copyWithSuccess(data)));
    } catch (e, stackTrace) {
      emit(
        state.copyWithFailure(errorHandler?.call(e, stackTrace)),
      );
    }
  }

  FutureOr<void> onEventUpdate(
      NetworkEventUpdate event, Emitter<NetworkStateBase<T>> emit) {
    emit(onStateChanged(event, state.copyWithSuccess(event.updatedData)));
  }

  FutureOr<void> onEventUpdateAsync(
      NetworkEventUpdateAsync event, Emitter<NetworkStateBase<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var data = await onUpdateDataAsync(event.updatedData);

      emit(onStateChanged(event, state.copyWithSuccess(data)));
    } catch (e, stackTrace) {
      emit(
        state.copyWithFailure(errorHandler?.call(e, stackTrace)),
      );
    }
  }

  Future<T> onLoadDataAsync();

  Future<T> onUpdateDataAsync(T updatedData) => Future.value(updatedData);

  NetworkStateBase<T> onStateChanged(
    NetworkEventBase event,
    covariant NetworkStateBase<T> state,
  ) =>
      state;
}
