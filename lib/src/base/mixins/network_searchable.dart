import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

mixin NetworkSearchableBlocMixin<T, S extends NetworkSearchableStateBase<T>>
    on NetworkBlocMixin<T, S>, NetworkSearchableBaseMixin<T, S> {
  @override
  void network() {
    on<NetworkEventSearch>(onEventSearch);
    on<NetworkEventSearchAsync>(onEventSearchAsync);
  }

  void search(String query) => add(NetworkEventSearch(query));

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

mixin NetworkSearchableBaseMixin<T, S extends NetworkSearchableStateBase<T>>
    on NetworkBaseMixin<T, S> {
  void search(String query) {
    emit(
      onDataChanged(
        DataChangeReason.searched,
        state.copyWith(query: query) as S,
      ),
    );
  }

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
        onDataChanged(
          DataChangeReason.searched,
          state.copyWithSuccess(searchedData) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(
          NetworkBaseMixin.errorHandler.onError(e, stackTrace)) as S);
    }
  }

  Future<T> onSearchAsync(String query) => Future.value();

  //additional methods
  Future<S> searchAsyncFuture(String query) {
    searchAsync(query);
    return getAsync();
  }
}
