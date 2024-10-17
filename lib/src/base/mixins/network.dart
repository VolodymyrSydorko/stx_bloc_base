import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// [NetworkBlocMixin] extends the functionality of the [Bloc] by adding [load], [update], and [updateAsync] convenience methods.
///
/// Each method overrides its corresponding method in [NetworkBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from[NetworkBaseMixin].
///
/// The [network] in the [NetworkBlocMixin] is triggered when [NetworkBloc] is instantiated.
///

mixin NetworkBlocMixin<T, S extends NetworkStateBase<T>>
    on Bloc<NetworkEventBase, S>, NetworkBaseMixin<T, S> {
  void network() {
    on<NetworkEventLoadAsync>(onEventLoadAsync);
    on<NetworkEventUpdate>(onEventUpdate);
    on<NetworkEventUpdateAsync>(onEventUpdateAsync);
  }

  /// [load] method of the [NetworkBlocMixin] overrides the [NetworkBaseMixin.load] and add the [NetworkEventLoadAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadAsync] calls the [NetworkBaseMixin.load] which invokes [onLoadAsync] internally.
  ///
  @override
  void load() => add(NetworkEventLoadAsync());

  /// [update] of the [NetworkBlocMixin] overrides the [NetworkBaseMixin.update] and adds the [NetworkEventUpdate] to the [Bloc].
  ///
  /// When the event is added, the [onEventUpdate] calls the [NetworkBaseMixin.update].
  ///
  @override
  void update(T updatedData) => add(NetworkEventUpdate(updatedData));

  /// [updateAsync] of the [NetworkBlocMixin] overrides the [NetworkBaseMixin.updateAsync] and adds the [NetworkEventUpdateAsync] to the [Bloc].
  ///
  /// When the event is added, the [onEventUpdateAsync] calls the [NetworkBaseMixin.updateAsync] which invokes [onUpdateAsync] internally.
  ///
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

/// [NetworkBaseMixin] is used in conjunction with [NetworkBloc] and [NetworkCubit] as a mixin on [BlocBase] providing the implementation of [load], [update], and [updateAsync] methods.
///
mixin NetworkBaseMixin<T, S extends NetworkStateBase<T>> on BlocBase<S> {
  /// use [load] to perform asynchronous operations, such as fetching data.
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

  /// use [update] to update the `data` locally.
  ///
  FutureOr<void> update(T updatedData) {
    emit(
      onStateChanged(
        DataChangeReason.updated,
        state.copyWithSuccess(updatedData) as S,
      ),
    );
  }

  /// use [updateAsync] to update the `data` asynchronously.
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

  /// [onLoadAsync] MUST be overridden when [NetworkBloc] or [NetworkCubit] is created.
  ///
  /// [onLoadAsync] is called  internally  when [load] method is called.
  Future<T> onLoadAsync();

  /// [onUpdateAsync] can optionally be overridden when creating [NetworkBloc] or [NetworkCubit].
  ///
  /// [onUpdateAsync] is called internally when [updateAsync] is called.
  /// Example usage
  /// ```dart
  ///   @override
  ///   Future<Data> onUpdateAsync(Data updatedData) async {
  ///     return someRepository.update(updatedData);
  ///   }
  /// ```
  ///
  Future<T> onUpdateAsync(T updatedData) => Future.value(updatedData);

  /// [onStateChanged] returns the state with modified `status`.
  ///
  /// It accepts [state] and [reason] that has
  /// been updated (typically via `copyWithSuccess`) and ensures that the `status`
  /// field is set to `NetworkStatus.success`.
  ///
  S onStateChanged(DataChangeReason reason, S state) =>
      state.copyWith(status: NetworkStatus.success) as S;

  // Additional methods
  ///
  /// Returns the first `state` if the [NetworkStatus] is **not** `loading`.
  ///
  ///  Listens to the stream and stops after the first match.
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

  /// [loadAsyncFuture] is a helper method that [load] data, then return the result of [getAsync].
  ///
  Future<S> loadAsyncFuture() {
    load();
    return getAsync();
  }

  /// [updateAsyncFuture] is a helper method that [updateAsync] first, then returns the result of [getAsync].
  ///
  Future<S> updateAsyncFuture(T updatedData) {
    updateAsync(updatedData);
    return getAsync();
  }
}
