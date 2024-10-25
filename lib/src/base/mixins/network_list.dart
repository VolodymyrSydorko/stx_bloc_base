import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:stx_bloc_base/src/helpers/list_extensions.dart';

import '../index.dart';

/// Extends the functionality of the [NetworkBlocMixin] by adding [addItem], [addItemAsync], [editItem], [editItemAsync], [removeItem], and [removeItemAsync] convenience methods which are commonly used for working with `List`s.
///
/// Each method overrides its corresponding method in [NetworkListBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkListBaseMixin].
///

mixin NetworkListBlocMixin<T, S extends NetworkListStateBase<T>>
    on NetworkBlocMixin<List<T>, S>, NetworkListBaseMixin<T, S> {
  @override

  /// The [network] in the [NetworkListBlocMixin] is triggered when [NetworkListBloc] is instantiated.
  ///
  void network() {
    on<NetworkEventAddItem<T>>(onEventAddItem);
    on<NetworkEventAddItemAsync<T>>(onEventAddItemAsync);
    on<NetworkEventEditItem<T>>(onEventEditItem);
    on<NetworkEventEditItemAsync<T>>(onEventEditItemAsync);
    on<NetworkEventRemoveItem>(onEventRemoveItem);
    on<NetworkEventRemoveItemAsync>(onEventRemoveItemAsync);
  }

  /// Overrides the [NetworkListBaseMixin.addItem] and add the [NetworkEventAddItem] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventAddItem] calls the [NetworkListBaseMixin.addItem].
  ///
  /// The optional [AddPosition] specifies where to add the item in the list: either at the end (default) or at the start.
  @override
  void addItem(T newItem, [AddPosition position = AddPosition.end]) =>
      add(NetworkEventAddItem(newItem, position: position));

  /// Overrides the [NetworkListBaseMixin.addItemAsync] and add the [NetworkEventAddItemAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventAddItemAsync] calls the [NetworkListBaseMixin.addItemAsync] which invokes [onAddItemAsync] internally.
  ///
  /// The optional [AddPosition] specifies where to add the item in the list: either at the end (default) or at the start.
  @override
  void addItemAsync(T newItem, [AddPosition position = AddPosition.end]) =>
      add(NetworkEventAddItemAsync(newItem, position));

  /// Overrides the [NetworkListBaseMixin.editItem] and add the [NetworkEventEditItem] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventEditItem] calls the [NetworkListBaseMixin.editItem].
  @override
  void editItem(T updatedItem) => add(NetworkEventEditItem(updatedItem));

  /// Overrides the [NetworkListBaseMixin.editItemAsync] and add the [NetworkEventEditItemAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventEditItemAsync] calls the [NetworkListBaseMixin.editItemAsync] which invokes [onEditItemAsync] internally.
  @override
  void editItemAsync(T updatedItem) =>
      add(NetworkEventEditItemAsync(updatedItem));

  /// Overrides the [NetworkListBaseMixin.removeItem] and add the [NetworkEventRemoveItem] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventRemoveItem] calls the [NetworkListBaseMixin.removeItem].
  @override
  void removeItem(T removedItem) => add(NetworkEventRemoveItem(removedItem));

  /// Overrides the [NetworkListBaseMixin.removeItemAsync] and add the [NetworkEventRemoveItemAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventRemoveItemAsync] calls the [NetworkListBaseMixin.removeItemAsync] which invokes [onRemoveItemAsync] internally.
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

/// Is used in conjunction with [NetworkListBloc] and [NetworkListCubit] as a mixin on [NetworkBaseMixin] providing the implementation of [addItem], [addItemAsync], [editItem], [editItemAsync], [removeItem], and [removeItemAsync] methods.
///
mixin NetworkListBaseMixin<T, S extends NetworkListStateBase<T>>
    on NetworkBaseMixin<List<T>, S> {
  /// Use [addItem] to add item to the `List` locally.
  ///
  ///  The optional [AddPosition] specifies where to add the item in the list: either at the end (default) or at the start.
  void addItem(T newItem, [AddPosition position = AddPosition.end]) {
    final items = [
      if (position.isStart) newItem,
      ...state.data,
      if (position.isEnd) newItem,
    ];

    emit(
      onStateChanged(
        DataChangeReason.itemAdded,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  /// Use [addItemAsync] to add item to the `List` asynchronously.
  ///
  /// The optional [AddPosition] specifies where to add the item in the list: either at the end (default) or at the start.
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
        onStateChanged(
          DataChangeReason.itemAdded,
          state.copyWithSuccess(items) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// Use [editItem] to edit item in the `List` locally.
  ///
  void editItem(T updatedItem) {
    final items = state.data.replaceWhere(
      (item) => equals(item, updatedItem),
      (_) => updatedItem,
    );

    emit(
      onStateChanged(
        DataChangeReason.itemEdited,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  /// Use [editItemAsync] to edit item in the `List` asynchronously.
  ///
  FutureOr<void> editItemAsync(T updatedItem) async {
    emit(state.copyWithLoading() as S);

    try {
      var updatedItemResponse = await onEditItemAsync(updatedItem);

      final items = state.data.replaceWhere(
        (item) => equals(item, updatedItemResponse),
        (_) => updatedItemResponse,
      );

      emit(
        onStateChanged(
          DataChangeReason.itemEdited,
          state.copyWithSuccess(items) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// Use [removeItem] to remove item from the `List` locally.
  ///
  void removeItem(T removedItem) {
    final items = [...state.data]..removeWhere(
        (item) => equals(item, removedItem),
      );

    emit(
      onStateChanged(
        DataChangeReason.itemRemoved,
        state.copyWithSuccess(items) as S,
      ),
    );
  }

  /// Use [removeItemAsync] to remove item from the `List` asynchronously.
  ///
  FutureOr<void> removeItemAsync(T removedItem) async {
    emit(state.copyWithLoading() as S);

    final oldItems = [...state.data];

    try {
      final items = [...state.data]..removeWhere(
          (item) => equals(item, removedItem),
        );

      emit(onStateChanged(
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
        ) as S,
      );
      addError(e, stackTrace);
    }
  }

  /// Can optionally be overridden when creating [NetworkListCubit] or [NetworkListBloc] in order to call [addItemAsync] on respective instances.
  Future<T> onAddItemAsync(T newItem) {
    return Future.value(newItem);
  }

  /// Can optionally be overridden when creating [NetworkListCubit] or [NetworkListBloc] in order to call [editItemAsync] on respective instances.
  Future<T> onEditItemAsync(T updatedItem) {
    return Future.value(updatedItem);
  }

  /// Can optionally be overridden when creating [NetworkListCubit] or [NetworkListBloc] in order to call [removeItemAsync] on respective instances.
  Future<bool> onRemoveItemAsync(T removedItem) {
    return Future.value(true);
  }

  /// The [equals] is used to identify the item during update or delete operations.
  ///
  /// Must be overridden when [NetworkListBloc] or [NetworkListCubit] is created. When extending [NetworkListBloc] or [NetworkListCubit], the IDE will warn that this method requires an override due to the missing implementation.
  bool equals(T item1, T item2);

  // Additional methods

  /// Adds item to a `List` first, then returns a `state` with updated data.
  ///
  Future<S> addItemAsyncFuture(T newItem) {
    addItemAsync(newItem);
    return getAsync();
  }

  /// Edits item in a `List` first, then returns a `state` with updated data.
  ///
  Future<S> editItemAsyncFuture(T updatedItem) {
    editItemAsync(updatedItem);
    return getAsync();
  }

  /// Removes item in a `List` first, then returns a `state` with updated data.
  ///
  Future<S> removeItemAsyncFuture(T removedItem) {
    removeItemAsync(removedItem);
    return getAsync();
  }
}
