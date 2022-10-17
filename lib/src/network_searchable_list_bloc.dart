import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'models.dart';
import 'network_bloc_base_event.dart';
import 'network_list_bloc.dart';

class NetworkSearchableListState<T> extends NetworkListState<T> {
  final List<T> visibleData;
  final String? query;

  const NetworkSearchableListState({
    super.status,
    super.data = const [],
    this.visibleData = const [],
    this.query,
    super.errorMessage,
  });

  @override
  NetworkSearchableListState<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkSearchableListState<T> copyWithSuccess(List<T> data) => copyWith(
        status: NetworkStatus.success,
        data: data,
        visibleData: data,
      );

  @override
  NetworkSearchableListState<T> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  @override
  NetworkSearchableListState<T> copyWith({
    NetworkStatus? status,
    List<T>? data,
    List<T>? visibleData,
    String? query,
    String? errorMessage,
  }) {
    return NetworkSearchableListState(
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

abstract class NetworkSearchableListBloc<T,
    S extends NetworkSearchableListState<T>> extends NetworkListBloc<T, S> {
  NetworkSearchableListBloc(
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
      NetworkEventSearch event, Emitter<NetworkSearchableListState<T>> emit) {
    emit(onStateChanged(event, state.copyWith(query: event.query)));
  }

  @protected
  FutureOr<void> onEventSearchAsync(NetworkEventSearchAsync event,
      Emitter<NetworkSearchableListState<T>> emit) async {
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

  Future<List<T>> onSearchAsync(String query) => Future.value([]);

  @override
  NetworkSearchableListState<T> onStateChanged(
    NetworkEventBase event,
    NetworkSearchableListState<T> state,
  ) =>
      state;

  //additional methods
  Future<S> searchAsyncFuture(String query) async {
    searchAsync(query);
    return getAsync();
  }
}
