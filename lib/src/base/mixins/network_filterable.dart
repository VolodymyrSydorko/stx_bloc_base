import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// Extends the functionality of [NetworkBlocMixin] by adding [filter] and [filterAsync] convenience methods. It inherits [load], [update], and [updateAsync] from [NetworkBlocMixin].
///
/// Each method overrides its corresponding method in [NetworkFilterableBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkFilterableBaseMixin].
///
mixin NetworkFilterableBlocMixin<T, F,
        S extends NetworkFilterableStateBase<T, F>>
    on NetworkBlocMixin<T, S>, NetworkFilterableBaseMixin<T, F, S> {
  @override

  /// The [network] in the [NetworkFilterableBlocMixin] is triggered when [NetworkFilterableBloc] is instantiated.
  ///
  void network() {
    on<NetworkEventFilter>(onEventFilter);
    on<NetworkEventFilterAsync>(onEventFilterAsync);
  }

  /// Overrides the [NetworkFilterableBaseMixin.filter] and add the [NetworkEventFilter] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventFilter] calls the the [NetworkFilterableBaseMixin.filter] which invokes [filter] internally.
  @override
  void filter(F filter) => add(NetworkEventFilter(filter));

  /// Overrides the [NetworkFilterableBaseMixin.filterAsync] and add the [NetworkEventFilterAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventFilterAsync] calls the the [NetworkFilterableBaseMixin.filterAsync] which invokes [filterAsync] internally.
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

/// Is used in conjunction with [NetworkFilterableBloc] and [NetworkFilterableCubit] and extends the functionality of [NetworkBaseMixin] providing the implementation of [filter] and [filterAsync] methods.

mixin NetworkFilterableBaseMixin<T, F,
    S extends NetworkFilterableStateBase<T, F>> on NetworkBaseMixin<T, S> {
  /// Use to change the `state` based on the applied filter locally.
  ///
  /// For this method to work properly, the [onStateChanged] MUST be overridden in the [NetworkFilterableCubit] or [NetworkFilterableBloc].
  ///
  void filter(F filter) {
    emit(
      onStateChanged(
          DataChangeReason.filtered, state.copyWith(filter: filter) as S),
    );
  }

  /// Use to asynchronously update the `state` based on the applied filter.
  ///
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
        onStateChanged(
          DataChangeReason.filtered,
          state.copyWithSuccess(filteredData) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// Can optionally be overridden when creating [NetworkFilterableCubit] or [NetworkFilterableBloc] in order to call [filterAsync] on respective instances.
  Future<T> onFilterAsync(F filter) => Future.value();

  // Additional methods
  /// Performs filtering, then returns a `state` with updated data.
  ///
  Future<S> filterAsyncFuture(F filter) {
    filterAsync(filter);
    return getAsync();
  }
}
