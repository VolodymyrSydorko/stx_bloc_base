import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'models.dart';
import 'network_bloc_base_event.dart';
import 'network_searchable_list_bloc.dart';

class NetworkFilterableListState<T, F> extends NetworkSearchableListState<T> {
  final F? filter;

  const NetworkFilterableListState({
    super.status,
    super.data = const [],
    super.visibleData,
    super.query,
    this.filter,
    super.errorMessage,
  });

  @override
  NetworkFilterableListState<T, F> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkFilterableListState<T, F> copyWithSuccess(List<T> data) => copyWith(
        status: NetworkStatus.success,
        data: data,
        visibleData: data,
      );

  @override
  NetworkFilterableListState<T, F> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  @override
  NetworkFilterableListState<T, F> copyWith({
    NetworkStatus? status,
    List<T>? data,
    List<T>? visibleData,
    String? query,
    F? filter,
    String? errorMessage,
  }) {
    return NetworkFilterableListState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [...super.props, filter];
}

abstract class NetworkFilterableListBloc<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListBloc<T, S> {
  NetworkFilterableListBloc(
    super.initialState, {
    super.errorHandler,
  }) {
    on<NetworkEventFilter<F>>(onEventFilter);
    on<NetworkEventFilterAsync<F>>(onEventFilterAsync);
  }

  void filter(F filter) => add(NetworkEventFilter<F>(filter));
  void filterAsync(F filter) => add(NetworkEventFilterAsync<F>(filter));

  @protected
  FutureOr<void> onEventFilter(NetworkEventFilter<F> event,
      Emitter<NetworkFilterableListState<T, F>> emit) {
    emit(onStateChanged(event, state.copyWith(filter: event.filter)));
  }

  @protected
  FutureOr<void> onEventFilterAsync(NetworkEventFilterAsync<F> event,
      Emitter<NetworkFilterableListState<T, F>> emit) async {
    emit(
      state.copyWith(
        status: NetworkStatus.loading,
        filter: event.filter,
      ),
    );

    try {
      final filteredData = await onFilterAsync(event.filter);

      emit(onStateChanged(event, state.copyWithSuccess(filteredData)));
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(errorHandler?.call(e, stackTrace)));
    }
  }

  Future<List<T>> onFilterAsync(F filter) => Future.value([]);

  @override
  NetworkFilterableListState<T, F> onStateChanged(
    NetworkEventBase event,
    NetworkFilterableListState<T, F> state,
  ) =>
      state;

  //additional methods
  Future<S> filterAsyncFuture(F filter) async {
    filterAsync(filter);
    return getAsync();
  }
}
