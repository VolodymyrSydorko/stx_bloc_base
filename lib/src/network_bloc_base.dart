import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models.dart';
import 'network_bloc_base_event.dart';

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

  String get errorMsg =>
      status.isFailure ? errorMessage ?? 'Something went wrong' : '';

  @override
  List<Object?> get props => [status, data, errorMessage];
}

abstract class NetworkBlocBase<T, S extends NetworkStateBase<T>>
    extends Bloc<NetworkEventBase, S> {
  final String? Function(Object, StackTrace)? errorHandler;

  NetworkBlocBase(
    super.initialState, {
    this.errorHandler,
  }) {
    on<NetworkEventLoadAsync>(onEventLoadAsync);
    on<NetworkEventUpdate>(onEventUpdate);
    on<NetworkEventUpdateAsync>(onEventUpdateAsync);
  }

  void load() => add(NetworkEventLoadAsync());
  void update(T updatedData) => add(NetworkEventUpdate(updatedData));
  void updateAsync(T updatedData) => add(NetworkEventUpdateAsync(updatedData));

  @protected
  FutureOr<void> onEventLoadAsync(
      NetworkEventLoadAsync event, Emitter<NetworkStateBase<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var data = await onLoadAsync();

      emit(onStateChanged(event, state.copyWithSuccess(data)));
    } catch (e, stackTrace) {
      emit(
        state.copyWithFailure(errorHandler?.call(e, stackTrace)),
      );
    }
  }

  @protected
  FutureOr<void> onEventUpdate(
      NetworkEventUpdate event, Emitter<NetworkStateBase<T>> emit) {
    emit(onStateChanged(event, state.copyWithSuccess(event.updatedData)));
  }

  @protected
  FutureOr<void> onEventUpdateAsync(
      NetworkEventUpdateAsync event, Emitter<NetworkStateBase<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var data = await onUpdateAsync(event.updatedData);

      emit(onStateChanged(event, state.copyWithSuccess(data)));
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(errorHandler?.call(e, stackTrace)));
    }
  }

  Future<T> onLoadAsync();

  Future<T> onUpdateAsync(T updatedData) => Future.value(updatedData);

  NetworkStateBase<T> onStateChanged(
    NetworkEventBase event,
    covariant NetworkStateBase<T> state,
  ) =>
      state;
}
