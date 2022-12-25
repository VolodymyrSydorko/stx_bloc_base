import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

mixin NetworkFilterableBlocMixin<T, F,
        S extends NetworkFilterableStateBase<T, F>>
    on NetworkBlocMixin<T, S>, NetworkFilterableBaseMixin<T, F, S> {
  @override
  void network() {
    on<NetworkEventFilter>(onEventFilter);
    on<NetworkEventFilterAsync>(onEventFilterAsync);
  }

  @override
  void filter(F filter) => add(NetworkEventFilter(filter));

  @override
  void filterAsync(F filter) => add(NetworkEventFilterAsync(filter));

  @protected
  FutureOr<void> onEventFilter(NetworkEventFilter event,
      Emitter<NetworkFilterableStateBase<T, F>> emit) {
    super.filter(event.filter);
  }

  @protected
  FutureOr<void> onEventFilterAsync(NetworkEventFilterAsync event,
      Emitter<NetworkFilterableStateBase<T, F>> emit) {
    return super.filterAsync(event.filter);
  }
}

mixin NetworkFilterableBaseMixin<T, F,
    S extends NetworkFilterableStateBase<T, F>> on NetworkBaseMixin<T, S> {
  void filter(F filter) {
    emit(
      onDataChanged(
          DataChangeReason.filtered, state.copyWith(filter: filter) as S),
    );
  }

  FutureOr<void> filterAsync(F filter) async {
    emit(
      state.copyWith(
        status: NetworkStatus.loading,
        filter: filter,
      ) as S,
    );

    try {
      final filteredData = await onFilterAsync(filter);

      emit(
        onDataChanged(
          DataChangeReason.filtered,
          state.copyWithSuccess(filteredData) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(
          NetworkBaseMixin.errorHandler.onError(e, stackTrace)) as S);
    }
  }

  Future<T> onFilterAsync(F filter) => Future.value();

  //additional methods
  Future<S> filterAsyncFuture(F filter) {
    filterAsync(filter);
    return getAsync();
  }
}
