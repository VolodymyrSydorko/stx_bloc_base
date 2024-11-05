import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// Extends the functionality of the [Bloc] by adding [load], [update], and [updateAsync] convenience methods.
///
/// Each method overrides its corresponding method in [NetworkBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkBaseMixin].
///

mixin NetworkBlocMixin<T, S extends NetworkStateBase<T>>
    on Bloc<NetworkEventBase, S>, NetworkBaseMixin<T, S> {
  /// The [network] in the [NetworkBlocMixin] is triggered when [NetworkBloc] is instantiated.
  ///
  void network() {
    on<NetworkEventLoadAsync>(onEventLoadAsync);
    on<NetworkEventUpdate>(onEventUpdate);
    on<NetworkEventUpdateAsync>(onEventUpdateAsync);
  }

  /// Overrides the [NetworkBaseMixin.load] and add the [NetworkEventLoadAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadAsync] calls the [NetworkBaseMixin.load] which invokes [onLoadAsync] internally.
  @override
  void load() => add(NetworkEventLoadAsync());

  /// Overrides the [NetworkBaseMixin.update] and adds the [NetworkEventUpdate] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventUpdate] calls the [NetworkBaseMixin.update].
  @override
  void update(T updatedData) => add(NetworkEventUpdate(updatedData));

  /// Overrides the [NetworkBaseMixin.updateAsync] and adds the [NetworkEventUpdateAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventUpdateAsync] calls the [NetworkBaseMixin.updateAsync] which invokes [onUpdateAsync] internally.
  @override
  void updateAsync(T updatedData) => add(NetworkEventUpdateAsync(updatedData));

  @protected
  FutureOr<void> onEventLoadAsync(
    NetworkEventLoadAsync event,
    Emitter<NetworkStateBase<T>> emit,
  ) {
    return super.load();
  }

  @protected
  FutureOr<void> onEventUpdate(
    NetworkEventUpdate event,
    Emitter<NetworkStateBase<T>> emit,
  ) {
    return super.update(event.updatedData);
  }

  @protected
  FutureOr<void> onEventUpdateAsync(
      NetworkEventUpdateAsync event, Emitter<NetworkStateBase<T>> emit) async {
    return super.updateAsync(event.updatedData);
  }
}

/// Is used in conjunction with [NetworkBloc] and [NetworkCubit] as a mixin on [BlocBase] providing the implementation of [load], [update], and [updateAsync] methods.
///
mixin NetworkBaseMixin<T, S extends NetworkStateBase<T>> on BlocBase<S> {
  /// Use [load] to perform asynchronous operations, such as fetching data.
  ///
  FutureOr<void> load() async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onLoadAsync();

      emit(
        onStateChanged(
          DataChangeReason.loaded,
          state.copyWithSuccess(data) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// Use [update] to update the `data` in a `state` locally.
  ///
  FutureOr<void> update(T updatedData) {
    emit(
      onStateChanged(
        DataChangeReason.updated,
        state.copyWithSuccess(updatedData) as S,
      ),
    );
  }

  /// Use [updateAsync] to update the `data` in a `state` asynchronously.
  ///

  FutureOr<void> updateAsync(T updatedData) async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onUpdateAsync(updatedData);

      emit(
        onStateChanged(
          DataChangeReason.updated,
          state.copyWithSuccess(data) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// [onLoadAsync] is called  internally  when [load] method is called.
  ///
  /// Must be overridden when [NetworkBloc] or [NetworkCubit] is created. When extending [NetworkBloc] or [NetworkCubit], the IDE will warn that this method requires an override due to the missing implementation.
  ///
  Future<T> onLoadAsync();

  ///  Can optionally be overridden when creating [NetworkBloc] or [NetworkCubit].
  ///
  /// [onUpdateAsync] is called internally when [updateAsync] is called.
  ///
  Future<T> onUpdateAsync(T updatedData) => Future.value(updatedData);

  /// Returns the `state` with modified `status`.
  ///
  /// Takes [state] and [reason] that have
  /// been updated (typically via `copyWithSuccess`) and ensures that the `status`
  /// field is set to `NetworkStatus.success`.
  ///
  S onStateChanged(DataChangeReason reason, S state) =>
      state.copyWith(status: NetworkStatus.success) as S;

  // Additional methods
  ///
  /// Starts listening to a stream of `state`s and returns the first `state` if the [NetworkStatus] is **not** `loading`. **Ensure** to trigger an event to prevent endless listening.
  ///
  Future<S> getAsync() {
    return stream.firstWhere((state) => !state.status.isLoading);
  }

  /// If the `state.status` is [NetworkStatus.initial] returns the result of [loadAsyncFuture].
  ///
  /// Otherwise, if it is [NetworkStatus.loading], it returns the result of [getAsync]. If neither condition is met, it returns the current `state`.
  ///
  Future<S> initLoadAsyncFuture() {
    if (state.status.isInitial) {
      return loadAsyncFuture();
    } else {
      return state.status.isLoading ? getAsync() : Future.value(state);
    }
  }

  /// Performs a `data` fetching, then returns a `state` with updated data.
  ///
  Future<S> loadAsyncFuture() {
    load();
    return getAsync();
  }

  /// Performs a `data` update, then return a `state`
  ///  with updated data.
  ///
  Future<S> updateAsyncFuture(T updatedData) {
    updateAsync(updatedData);
    return getAsync();
  }
}
