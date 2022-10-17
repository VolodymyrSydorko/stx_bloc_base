import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:stx_bloc_base/src/helpers/list_extensions.dart';

import 'models.dart';
import 'network_bloc_base.dart';
import 'network_bloc_base_event.dart';

class NetworkListState<T> extends NetworkStateBase<List<T>> {
  const NetworkListState({
    super.status,
    super.data = const [],
    super.errorMessage,
  });

  @override
  NetworkListState<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkListState<T> copyWithSuccess(List<T> data) =>
      copyWith(status: NetworkStatus.success, data: data);

  @override
  NetworkListState<T> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  @override
  NetworkListState<T> copyWith({
    NetworkStatus? status,
    List<T>? data,
    String? errorMessage,
  }) {
    return NetworkListState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

abstract class NetworkListBloc<T, S extends NetworkListState<T>>
    extends NetworkBlocBase<List<T>, S> {
  NetworkListBloc(
    super.initialState, {
    super.errorHandler,
  }) {
    on<NetworkEventAdd<T>>(onEventAddItem);
    on<NetworkEventAddItemAsync<T>>(onEventAddItemAsync);
    on<NetworkEventEditItem<T>>(onEventEditItem);
    on<NetworkEventEditItemAsync<T>>(onEventEditItemAsync);
    on<NetworkEventRemoveItem>(onEventRemoveItem);
    on<NetworkEventRemoveItemAsync>(onEventRemoveItemAsync);
  }

  void addItem(T newItem) => add(NetworkEventAdd(newItem));
  void addItemAsync(T newItem) => add(NetworkEventAddItemAsync(newItem));

  void editItem(T updatedItem) => add(NetworkEventEditItem(updatedItem));
  void editItemAsync(T updatedItem) =>
      add(NetworkEventEditItemAsync(updatedItem));

  void removeItem(T item) => add(NetworkEventRemoveItem(item));
  void removeItemAsync(T item) => add(NetworkEventRemoveItemAsync(item));

  @protected
  FutureOr<void> onEventAddItem(
      NetworkEventAdd<T> event, Emitter<NetworkListState<T>> emit) {
    final items = [
      if (event.position.isStart) event.newItem,
      ...state.data,
      if (event.position.isEnd) event.newItem,
    ];

    emit(onStateChanged(event, state.copyWithSuccess(items)));
  }

  @protected
  FutureOr<void> onEventAddItemAsync(NetworkEventAddItemAsync<T> event,
      Emitter<NetworkListState<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var newItem = await onAddItemAsync(event.newItem);

      final items = [
        if (event.position.isStart) newItem,
        ...state.data,
        if (event.position.isEnd) newItem,
      ];

      emit(onStateChanged(event, state.copyWithSuccess(items)));
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(errorHandler?.call(e, stackTrace)));
    }
  }

  @protected
  FutureOr<void> onEventEditItem(
      NetworkEventEditItem<T> event, Emitter<NetworkListState<T>> emit) {
    final items = state.data.replaceWhere(
      (item) => equals(item, event.updatedItem),
      (_) => event.updatedItem,
    );

    emit(onStateChanged(event, state.copyWithSuccess(items)));
  }

  @protected
  FutureOr<void> onEventEditItemAsync(NetworkEventEditItemAsync<T> event,
      Emitter<NetworkListState<T>> emit) async {
    emit(state.copyWithLoading());

    try {
      var updatedItem = await onEditItemAsync(event.updatedItem);

      final items = state.data.replaceWhere(
        (item) => equals(item, updatedItem),
        (_) => updatedItem,
      );

      emit(onStateChanged(event, state.copyWithSuccess(items)));
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(errorHandler?.call(e, stackTrace)));
    }
  }

  @protected
  FutureOr<void> onEventRemoveItem(
      NetworkEventRemoveItem event, Emitter<NetworkListState<T>> emit) {
    final items = [...state.data]..removeWhere(
        (item) => equals(item, event.item),
      );

    emit(onStateChanged(event, state.copyWithSuccess(items)));
  }

  @protected
  FutureOr<void> onEventRemoveItemAsync(NetworkEventRemoveItemAsync event,
      Emitter<NetworkListState<T>> emit) async {
    emit(state.copyWithLoading());

    final oldItems = [...state.data];

    try {
      final items = [...state.data]..removeWhere(
          (item) => equals(item, event.item),
        );

      emit(onStateChanged(event, state.copyWithSuccess(items)));

      final isDeleted = await onDeleteItemAsync(event.item);

      if (!isDeleted) {
        emit(state.copyWith(status: NetworkStatus.failure, data: oldItems));
      }
    } catch (e, stackTrace) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          data: oldItems,
          errorMessage: errorHandler?.call(e, stackTrace),
        ),
      );
    }
  }

  Future<T> onAddItemAsync(T newItem) {
    return Future.value(newItem);
  }

  Future<T> onEditItemAsync(T updatedItem) {
    return Future.value(updatedItem);
  }

  Future<bool> onDeleteItemAsync(T item) {
    return Future.value(true);
  }

  bool equals(T item1, T item2);

  @override
  NetworkListState<T> onStateChanged(
    NetworkEventBase event,
    NetworkListState<T> state,
  ) =>
      state;

  //additional methods
  Future<S> addItemAsyncFuture(T newItem) async {
    addItemAsync(newItem);
    return getAsync();
  }

  Future<S> editItemAsyncFuture(T updatedItem) async {
    editItemAsync(updatedItem);
    return getAsync();
  }

  Future<S> removeItemAsyncFuture(T item) async {
    removeItemAsync(item);
    return getAsync();
  }
}
