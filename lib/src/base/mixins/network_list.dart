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
    on<NetworkEventRemoveItem<T>>(onEventRemoveItem);
    on<NetworkEventRemoveItemAsync<T>>(onEventRemoveItemAsync);
  }

  @override
  void addItem(T newItem, [AddPosition position = AddPosition.end]) =>
      add(NetworkEventAddItem(newItem, position: position));

  @override
  void addItemAsync(
    T newItem, {
    AddPosition position = AddPosition.end,
    bool force = true,
  }) =>
      add(NetworkEventAddItemAsync(
        newItem,
        position: position,
        force: force,
      ));

  @override
  void editItem(T updatedItem) => add(NetworkEventEditItem(updatedItem));

  @override
  void editItemAsync(T updatedItem, {bool force = true}) =>
      add(NetworkEventEditItemAsync(updatedItem, force: force));

  @override
  void removeItem(T removedItem) => add(NetworkEventRemoveItem(removedItem));

  @override
  void removeItemAsync(T removedItem, {bool force = true}) =>
      add(NetworkEventRemoveItemAsync(removedItem, force: force));

  @protected
  FutureOr<void> onEventAddItem(
      NetworkEventAddItem<T> event, Emitter<NetworkListStateBase<T>> emit) {
    super.addItem(event.newItem, event.position);
  }

  @protected
  FutureOr<void> onEventAddItemAsync(NetworkEventAddItemAsync<T> event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.addItemAsync(event.newItem,
        position: event.position, force: event.force);
  }

  @protected
  FutureOr<void> onEventEditItem(
      NetworkEventEditItem<T> event, Emitter<NetworkListStateBase<T>> emit) {
    super.editItem(event.updatedItem);
  }

  @protected
  FutureOr<void> onEventEditItemAsync(NetworkEventEditItemAsync<T> event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.editItemAsync(event.updatedItem, force: event.force);
  }

  @protected
  FutureOr<void> onEventRemoveItem(
      NetworkEventRemoveItem<T> event, Emitter<NetworkListStateBase<T>> emit) {
    super.removeItem(event.item);
  }

  @protected
  FutureOr<void> onEventRemoveItemAsync(NetworkEventRemoveItemAsync<T> event,
      Emitter<NetworkListStateBase<T>> emit) {
    return super.removeItemAsync(event.item, force: event.force);
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
      onStateChanged(
        state.copyWithSuccess(
          items,
          reason: DataChangeReason.itemAdded,
        ) as S,
      ),
    );
  }

  FutureOr<void> addItemAsync(
    T newItem, {
    AddPosition position = AddPosition.end,
    bool force = true,
  }) async {
    final previousState = state;

    emit(state.copyWithLoading() as S);

    try {
      if (force) {
        final items = [
          if (position.isStart) newItem,
          ...state.data,
          if (position.isEnd) newItem,
        ];

        emit(
          onStateChanged(
            state.copyWith(
              data: items,
              changeReason: DataChangeReason.itemAdded,
            ) as S,
          ),
        );
      }

      var newItemResponse = await onAddItemAsync(newItem);

      final items = force
          ? state.data.replaceWhere(
              (item) => identical(item, newItem),
              (_) => newItemResponse,
            )
          : [
              if (position.isStart) newItemResponse,
              ...state.data,
              if (position.isEnd) newItemResponse
            ];

      emit(
        onStateChanged(
          state.copyWithSuccess(
            items,
            reason: DataChangeReason.itemAdded,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(previousState.copyWithFailure(FailureReason.addItem) as S);

      addError(e, stackTrace);
    }
  }

  void editItem(T updatedItem) {
    final items = state.data.replaceWhere(
      (item) => equals(item, updatedItem),
      (_) => updatedItem,
    );

    emit(
      onStateChanged(
        state.copyWithSuccess(
          items,
          reason: DataChangeReason.itemEdited,
        ) as S,
      ),
    );
  }

  FutureOr<void> editItemAsync(
    T updatedItem, {
    bool force = true,
  }) async {
    emit(state.copyWithLoading() as S);

    final previousState = state;
    final itemIndex = previousState.data.indexWhere(
      (item) => equals(updatedItem, item),
    );

    try {
      if (force) {
        final items = [...state.data]..replaceAt(
            itemIndex,
            updatedItem,
          );

        emit(
          onStateChanged(
            state.copyWith(
              data: items,
              changeReason: DataChangeReason.itemEdited,
            ) as S,
          ),
        );
      }

      var updatedItemResponse = await onEditItemAsync(updatedItem);

      final items = [...previousState.data]..replaceAt(
          itemIndex,
          updatedItemResponse,
        );

      emit(
        onStateChanged(
          previousState.copyWithSuccess(
            items,
            reason: DataChangeReason.itemEdited,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(previousState.copyWithFailure(FailureReason.editItem) as S);
      addError(e, stackTrace);
    }
  }

  void removeItem(T removedItem) {
    final items = [...state.data]..removeWhere(
        (item) => equals(item, removedItem),
      );

    emit(
      onStateChanged(
        state.copyWithSuccess(
          items,
          reason: DataChangeReason.itemRemoved,
        ) as S,
      ),
    );
  }

  FutureOr<void> removeItemAsync(
    T removedItem, {
    bool force = false,
  }) async {
    emit(state.copyWithLoading() as S);

    final previousState = state;

    try {
      final itemIndex = state.data.indexWhere(
        (item) => equals(removedItem, item),
      );

      if (force) {
        final items = [...state.data]..removeAt(itemIndex);

        emit(
          onStateChanged(
            state.copyWith(
              data: items,
              changeReason: DataChangeReason.itemRemoved,
            ) as S,
          ),
        );
      }

      final isDeleted = await onRemoveItemAsync(removedItem);

      if (isDeleted) {
        final items = [...previousState.data]..removeAt(itemIndex);

        emit(
          onStateChanged(
            state.copyWithSuccess(
              items,
              reason: DataChangeReason.itemRemoved,
            ) as S,
          ),
        );
      } else {
        emit(
          previousState.copyWithFailure(FailureReason.removeItem) as S,
        );
      }
    } catch (e, stackTrace) {
      emit(previousState.copyWithFailure(FailureReason.removeItem) as S);
      addError(e, stackTrace);
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
