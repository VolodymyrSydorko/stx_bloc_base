import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// Extends the functionality of [NetworkBlocMixin] by adding [loadExtra] and [loadWithExtra] convenience methods. It inherits [load], [update], and [updateAsync] from [NetworkBlocMixin].
///
/// Each method overrides its corresponding method in [NetworkExtraBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkExtraBaseMixin].

mixin NetworkExtraBlocMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBlocMixin<T, S>, NetworkExtraBaseMixin<T, E, S> {
  /// Must be called `super.network()` when [NetworkBloc] with NetworkExtraBlocMixin is instantiated.
  @override
  void network() {
    on<NetworkEventLoadExtraAsync>(onEventLoadExtraAsync);
    on<NetworkEventLoadWithExtraAsync>(onEventLoadWithExtraAsync);
  }

  /// Overrides the [NetworkExtraBaseMixin.loadExtra] and add the [NetworkEventLoadExtraAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadExtraAsync] calls the the [NetworkExtraBaseMixin.loadExtra] which invokes [onLoadExtraAsync] internally.
  @override
  void loadExtra() => add(NetworkEventLoadExtraAsync());

  /// Overrides the [NetworkExtraBaseMixin.loadWithExtra] and add the [NetworkEventLoadWithExtraAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadWithExtraAsync] calls the the [NetworkExtraBaseMixin.loadWithExtra] which invokes [onLoadWithExtraAsync] internally.
  @override
  void loadWithExtra() => add(NetworkEventLoadWithExtraAsync());

  @protected
  FutureOr<void> onEventLoadExtraAsync(NetworkEventLoadExtraAsync event,
      Emitter<NetworkExtraStateBase<T, E>> emit) {
    return super.loadExtra();
  }

  @protected
  FutureOr<void> onEventLoadWithExtraAsync(NetworkEventLoadWithExtraAsync event,
      Emitter<NetworkExtraStateBase<T, E>> emit) {
    return super.loadWithExtra();
  }
}

/// Utility mixin that can be mixed in to any of the existing implementations of [NetworkBloc]/[NetworkCubit] which holds the [NetworkExtraState] and its' descendants as a `state`. Provides the implementation of [loadWithExtra] and [loadExtra] methods.
///
mixin NetworkExtraBaseMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBaseMixin<T, S> {
  /// Use [loadWithExtra] to fetch data with an extra data. Combines the [load] and [loadExtra] methods.
  ///
  /// The [onLoadWithExtraAsync] is invoked when [loadWithExtra] method is called from the UI.
  FutureOr<void> loadWithExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onLoadWithExtraAsync();

      emit(
        onStateChanged(
          DataChangeReason.loaded,
          state.copyWithSuccess(data.$1, data.$2) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// The [onLoadExtraAsync] is invoked when [loadExtra] method is called from the UI.
  ///
  FutureOr<void> loadExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      var extraData = await onLoadExtraAsync();

      emit(
        onStateChanged(
          DataChangeReason.extraLoaded,
          state.copyWith(
            status: NetworkStatus.success,
            extraData: extraData,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// [onLoadAsync] is called  internally  when [load] method is called.
  ///
  ///  Can optionally be overridden when creating [NetworkBloc] or [NetworkCubit].
  @override
  Future<T> onLoadAsync() {
    throw UnimplementedError();
  }

  /// [onLoadExtraAsync] is called internally when [loadExtra] method is called.
  ///
  /// Can optionally be overridden when extending any [NetworkBloc] or [NetworkCubit] with [NetworkExtraBaseMixin] to fetch the extra data.
  ///
  Future<E> onLoadExtraAsync() {
    throw UnimplementedError();
  }

  /// [onLoadWithExtraAsync] is called internally when [loadWithExtra] method is called.
  ///
  /// If the [onLoadAsync] and [onLoadExtraAsync] have its own implementation, this method can be left unimplemented. In this case it will internally call the [onLoadAsync] and [onLoadWithExtraAsync] and return the result of both methods.
  ///
  /// A custom implementation can be provided here without overriding the [onLoadAsync] and [onLoadExtraAsync].
  ///
  Future<(T data, E extra)> onLoadWithExtraAsync() async {
    return (await onLoadAsync(), await onLoadExtraAsync());
  }

  // Additional methods
  /// Performs a `data` with `extraData` fetching, then returns a `state` with updated data.
  ///
  Future<S> loadWithExtraAsyncFuture() {
    loadWithExtra();
    return getAsync();
  }

  /// Performs an `extraData` fetching, then returns a `state` with updated data.
  ///
  Future<S> loadExtraAsyncFuture() {
    loadExtra();
    return getAsync();
  }
}
