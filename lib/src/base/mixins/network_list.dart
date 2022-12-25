import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:stx_bloc_base/src/helpers/list_extensions.dart';

import '../index.dart';

mixin NetworkListBlocMixin<T, S extends NetworkListStateBase<T>>
    on NetworkBlocMixin<List<T>, S>, NetworkListBaseMixin<T, S> {
  @override
  void network() {
    on<NetworkEventAddItem<T>>(onEventAddItem);
    on<NetworkEventAddItemAsync<T>>(onEventAddItemAsync);
    on<NetworkEventEditItem<T>>(onEventEditItem);
    on<NetworkEventEditItemAsync<T>>(onEventEditItemAsync);
    on<NetworkEventRemoveItem>(onEventRemoveItem);
    on<NetworkEventRemoveItemAsync>(onEventRemoveItemAsync);
  }

  @override
  void addItem(T newItem, [AddPosition position = AddPosition.end]) =>
      add(NetworkEventAddItem(newItem, position: position));

  @override
  void addItemAsync(T newItem, [AddPosition position = AddPosition.end]) =>
      add(NetworkEventAddItemAsync(newItem, position));

  @override
  void editItem(T updatedItem) => add(NetworkEventEditItem(updatedItem));

  @override
  void editItemAsync(T updatedItem) =>
      add(NetworkEventEditItemAsync(updatedItem));

  @override
  void removeItem(T removedItem) => add(NetworkEventRemoveItem(removedItem));

  @override
  void removeItemAsync(T removedItem) =>
      add(NetworkEventRemoveItemAsync(removedItem));

  @protected
  FutureOr<void> onEventAddItem(
      NetworkEventAddItem<T> event, Emitter<NetworkListStateBase<T>> emit) {
    super.addItem(event.newItem, event.position);
  }

  @protected
  FutureOr<void> onEventAddItemAsync(NetworkEventAddItemAsync<T> event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.addItemAsync(event.newItem, event.position);
  }

  @protected
  FutureOr<void> onEventEditItem(
      NetworkEventEditItem<T> event, Emitter<NetworkListStateBase<T>> emit) {
    super.editItem(event.updatedItem);
  }

  @protected
  FutureOr<void> onEventEditItemAsync(NetworkEventEditItemAsync<T> event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.editItemAsync(event.updatedItem);
  }

  @protected
  FutureOr<void> onEventRemoveItem(
      NetworkEventRemoveItem event, Emitter<NetworkListStateBase<T>> emit) {
    super.removeItem(event.item);
  }

  @protected
  FutureOr<void> onEventRemoveItemAsync(NetworkEventRemoveItemAsync event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.removeItemAsync(event.item);
  }
}

mixin NetworkListBaseMixin<T, S extends NetworkListStateBase<T>>
    on NetworkBaseMixin<List<T>, S> {
  void addItem(T newItem, [AddPosition position = AddPosition.end]) {
    final items = [
      if (position.isStart) newItem,
      ...state.data,
      if (position.isEnd) newItem,
    ];

    emit(
      onDataChanged(
        DataChangeReason.itemAdded,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  FutureOr<void> addItemAsync(T newItem,
      [AddPosition position = AddPosition.end]) async {
    emit(state.copyWithLoading() as S);

    try {
      var newItemResponse = await onAddItemAsync(newItem);

      final items = [
        if (position.isStart) newItemResponse,
        ...state.data,
        if (position.isEnd) newItemResponse,
      ];

      emit(
        onDataChanged(
          DataChangeReason.itemAdded,
          state.copyWithSuccess(items) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(
          NetworkBaseMixin.errorHandler.onError(e, stackTrace)) as S);
    }
  }

  void editItem(T updatedItem) {
    final items = state.data.replaceWhere(
      (item) => equals(item, updatedItem),
      (_) => updatedItem,
    );

    emit(
      onDataChanged(
        DataChangeReason.itemEdited,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  FutureOr<void> editItemAsync(T updatedItem) async {
    emit(state.copyWithLoading() as S);

    try {
      var updatedItemResponse = await onEditItemAsync(updatedItem);

      final items = state.data.replaceWhere(
        (item) => equals(item, updatedItemResponse),
        (_) => updatedItemResponse,
      );

      emit(
        onDataChanged(
          DataChangeReason.itemEdited,
          state.copyWithSuccess(items) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(
          NetworkBaseMixin.errorHandler.onError(e, stackTrace)) as S);
    }
  }

  void removeItem(T removedItem) {
    final items = [...state.data]..removeWhere(
        (item) => equals(item, removedItem),
      );

    emit(
      onDataChanged(
        DataChangeReason.itemRemoved,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  FutureOr<void> removeItemAsync(T removedItem) async {
    emit(state.copyWithLoading() as S);

    final oldItems = [...state.data];

    try {
      final items = [...state.data]..removeWhere(
          (item) => equals(item, removedItem),
        );

      emit(onDataChanged(
          DataChangeReason.itemRemoved, state.copyWithSuccess(items) as S));

      final isDeleted = await onRemoveItemAsync(removedItem);

      if (!isDeleted) {
        emit(
          state.copyWith(status: NetworkStatus.failure, data: oldItems) as S,
        );
      }
    } catch (e, stackTrace) {
      emit(
        state.copyWith(
          status: NetworkStatus.failure,
          data: oldItems,
          errorMessage: NetworkBaseMixin.errorHandler.onError(e, stackTrace),
        ) as S,
      );
    }
  }

  Future<T> onAddItemAsync(T newItem) {
    return Future.value(newItem);
  }

  Future<T> onEditItemAsync(T updatedItem) {
    return Future.value(updatedItem);
  }

  Future<bool> onRemoveItemAsync(T removedItem) {
    return Future.value(true);
  }

  bool equals(T item1, T item2);

  //additional methods
  Future<S> addItemAsyncFuture(T newItem) {
    addItemAsync(newItem);
    return getAsync();
  }

  Future<S> editItemAsyncFuture(T updatedItem) {
    editItemAsync(updatedItem);
    return getAsync();
  }

  Future<S> removeItemAsyncFuture(T removedItem) {
    removeItemAsync(removedItem);
    return getAsync();
  }
}
