import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// Extends the functionality of [NetworkBlocMixin] by adding [search] and [searchAsync] convenience methods. It inherits [load], [update], and [updateAsync] from [NetworkBlocMixin].
///
/// Each method overrides its corresponding method in [NetworkSearchableBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkSearchableBaseMixin].
///
/// The [network] in the [NetworkSearchableBlocMixin] is triggered when [NetworkSearchableBloc] is instantiated.
///
mixin NetworkSearchableBlocMixin<T, S extends NetworkSearchableStateBase<T>>
    on NetworkBlocMixin<T, S>, NetworkSearchableBaseMixin<T, S> {
  @override
  void network() {
    on<NetworkEventSearch>(onEventSearch);
    on<NetworkEventSearchAsync>(onEventSearchAsync);
  }

  /// [search] method of the [NetworkSearchableBlocMixin] overrides the [NetworkSearchableBaseMixin.search] and add the [NetworkEventSearch] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventSearch] calls the the [NetworkSearchableBaseMixin.search] which invokes [search] internally.
  @override
  void search(String query) => add(NetworkEventSearch(query));

  /// [searchAsync] of the [NetworkSearchableBlocMixin] overrides the [NetworkSearchableBaseMixin.searchAsync] and adds the [NetworkEventUpdateAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventSearchAsync] calls the [NetworkSearchableBaseMixin.searchAsync] which invokes [searchAsync] internally.
  ///
  @override
  void searchAsync(String query) => add(NetworkEventSearchAsync(query));

  @protected
  FutureOr<void> onEventSearch(
      NetworkEventSearch event, Emitter<NetworkSearchableStateBase<T>> emit) {
    super.search(event.query);
  }

  @protected
  FutureOr<void> onEventSearchAsync(NetworkEventSearchAsync event,
      Emitter<NetworkSearchableStateBase<T>> emit) {
    return super.searchAsync(event.query);
  }
}

/// Is used in conjunction with [NetworkSearchableBloc] and [NetworkSearchableCubit] and extends the functionality of [NetworkBaseMixin] providing the implementation of [search] and [searchAsync] methods.
///
mixin NetworkSearchableBaseMixin<T, S extends NetworkSearchableStateBase<T>>
    on NetworkBaseMixin<T, S> {
  /// Use to change the state based on the passed query locally.
  ///
  /// For this method to work properly, the [onStateChanged] MUST be overridden in the [NetworkSearchableCubit] or [NetworkSearchableBloc].
  ///
  void search(String query) {
    emit(
      onStateChanged(
        DataChangeReason.searched,
        state.copyWith(query: query) as S,
      ),
    );
  }

  /// Use to asynchronously update the state based on the passed query.
  ///
  /// For this method to work properly, the [onStateChanged] MUST be overridden in the [NetworkSearchableCubit] or [NetworkSearchableBloc].
  ///
  FutureOr<void> searchAsync(String query) async {
    emit(
      state.copyWith(
        status: NetworkStatus.loading,
        query: query,
      ) as S,
    );

    try {
      final searchedData = await onSearchAsync(query);

      emit(
        onStateChanged(
          DataChangeReason.searched,
          state.copyWithSuccess(searchedData) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// [onSearchAsync] can optionally be overridden when creating [NetworkSearchableCubit] or [NetworkSearchableBloc] in order to call [searchAsync] on respective instances.
  Future<T> onSearchAsync(String query) => Future.value();

  // Additional methods

  /// Similarly to [NetworkBaseMixin.loadAsyncFuture] and [NetworkBaseMixin.updateAsyncFuture], this is a helper method that [searchAsync] first, then returns the result of [getAsync].
  Future<S> searchAsyncFuture(String query) {
    searchAsync(query);
    return getAsync();
  }
}
