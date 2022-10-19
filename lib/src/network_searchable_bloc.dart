import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'models.dart';
import 'network_bloc_base.dart';
import 'network_bloc_base_event.dart';

class NetworkSearchableState<T> extends NetworkStateBase<T> {
  final T visibleData;
  final String? query;

  const NetworkSearchableState({
    super.status,
    required super.data,
    required this.visibleData,
    this.query,
    super.errorMessage,
  });

  @override
  NetworkSearchableState<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkSearchableState<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data, visibleData: data);

  @override
  NetworkSearchableState<T> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  @override
  NetworkSearchableState<T> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
    String? errorMessage,
  }) {
    return NetworkSearchableState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [...super.props, visibleData, query];
}

abstract class NetworkSearchableBloc<T, S extends NetworkSearchableState<T>>
    extends NetworkBlocBase<T, S> {
  NetworkSearchableBloc(
    super.initialState, {
    super.errorHandler,
  }) {
    on<NetworkEventSearch>(onEventSearch);
    on<NetworkEventSearchAsync>(onEventSearchAsync);
  }

  void search(String query) => add(NetworkEventSearch(query));
  void searchAsync(String query) => add(NetworkEventSearchAsync(query));

  @protected
  FutureOr<void> onEventSearch(
      NetworkEventSearch event, Emitter<NetworkSearchableState<T>> emit) {
    emit(onStateChanged(event, state.copyWith(query: event.query)));
  }

  @protected
  FutureOr<void> onEventSearchAsync(NetworkEventSearchAsync event,
      Emitter<NetworkSearchableState<T>> emit) async {
    emit(
      state.copyWith(
        status: NetworkStatus.loading,
        query: event.query,
      ),
    );

    try {
      final searchedData = await onSearchAsync(event.query);

      emit(onStateChanged(event, state.copyWithSuccess(searchedData)));
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(errorHandler?.call(e, stackTrace)));
    }
  }

  Future<T> onSearchAsync(String query) => Future.value();

  @override
  NetworkSearchableState<T> onStateChanged(
    NetworkEventBase event,
    NetworkSearchableState<T> state,
  ) =>
      state;

  //additional methods
  Future<S> searchAsyncFuture(String query) {
    searchAsync(query);
    return getAsync();
  }
}
