import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'models.dart';
import 'network_base_bloc_event.dart';
import 'network_searchable_bloc.dart';

class NetworkFilterableState<T, F> extends NetworkSearchableState<T> {
  final F? filter;

  const NetworkFilterableState({
    super.status,
    required super.data,
    required super.visibleData,
    super.query,
    this.filter,
    super.errorMessage,
  });

  @override
  NetworkFilterableState<T, F> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkFilterableState<T, F> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data, visibleData: data);

  @override
  NetworkFilterableState<T, F> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  @override
  NetworkFilterableState<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
    F? filter,
    String? errorMessage,
  }) {
    return NetworkFilterableState(
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

abstract class NetworkFilterableBloc<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableBloc<T, S> {
  NetworkFilterableBloc(
    super.initialState, {
    super.errorHandler,
  }) {
    on<NetworkEventFilter<F>>(onEventFilter);
    on<NetworkEventFilterAsync<F>>(onEventFilterAsync);
  }

  void filter(F filter) => add(NetworkEventFilter<F>(filter));
  void filterAsync(F filter) => add(NetworkEventFilterAsync<F>(filter));

  FutureOr<void> onEventFilter(
      NetworkEventFilter event, Emitter<NetworkFilterableState<T, F>> emit) {
    emit(onStateChanged(event, state.copyWith(filter: event.filter)));
  }

  FutureOr<void> onEventFilterAsync(NetworkEventFilterAsync<F> event,
      Emitter<NetworkFilterableState<T, F>> emit) async {
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

  Future<T> onFilterAsync(F filter) => Future.value();

  @override
  NetworkFilterableState<T, F> onStateChanged(
    NetworkEventBase event,
    NetworkFilterableState<T, F> state,
  ) =>
      state;
}
