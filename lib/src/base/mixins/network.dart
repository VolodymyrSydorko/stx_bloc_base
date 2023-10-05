import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

mixin NetworkBlocMixin<T, S extends NetworkStateBase<T>>
    on Bloc<NetworkEventBase, S>, NetworkBaseMixin<T, S> {
  void network() {
    on<NetworkEventLoadAsync>(onEventLoadAsync);
    on<NetworkEventUpdate>(onEventUpdate);
    on<NetworkEventUpdateAsync>(onEventUpdateAsync);
  }

  @override
  void load() => add(NetworkEventLoadAsync());
  @override
  void update(T updatedData) => add(NetworkEventUpdate(updatedData));
  @override
  void updateAsync(T updatedData, {bool force = true}) =>
      add(NetworkEventUpdateAsync(updatedData, force: force));

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
    return super.updateAsync(event.updatedData, force: event.force);
  }
}

mixin NetworkBaseMixin<T, S extends NetworkStateBase<T>> on BlocBase<S> {
  // S? _lastActiveState;

  // S get lastActiveState => _lastActiveState ?? state;

  FutureOr<void> load() async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onLoadAsync();

      emit(
        onStateChanged(
          state.copyWithSuccess(
            data,
            reason: DataChangeReason.loaded,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(FailureReason.load) as S);
      addError(e, stackTrace);
    }
  }

  FutureOr<void> update(T updatedData) {
    emit(
      onStateChanged(
        state.copyWithSuccess(
          updatedData,
          reason: DataChangeReason.updated,
        ) as S,
      ),
    );
  }

  FutureOr<void> updateAsync(T updatedData, {bool force = true}) async {
    emit(state.copyWithLoading() as S);

    final previousState = state;

    try {
      if (force) {
        emit(
          onStateChanged(
            state.copyWith(
              data: updatedData,
              changeReason: DataChangeReason.updated,
            ) as S,
          ),
        );
      }

      var data = await onUpdateAsync(updatedData);

      emit(
        onStateChanged(
          previousState.copyWithSuccess(
            data,
            reason: DataChangeReason.updated,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(previousState.copyWithFailure(FailureReason.update) as S);
      addError(e, stackTrace);
    }
  }

  Future<T> onLoadAsync();

  Future<T> onUpdateAsync(T updatedData) => Future.value(updatedData);

  S onStateChanged(S state) => state;

  //additional methods
  Future<S> getAsync() {
    return stream.firstWhere((state) => !state.status.isLoading);
  }

  Future<S> initLoadAsyncFuture() {
    if (state.status.isInitial) {
      return loadAsyncFuture();
    } else {
      return state.status.isLoading ? getAsync() : Future.value(state);
    }
  }

  Future<S> loadAsyncFuture() {
    load();
    return getAsync();
  }

  Future<S> updateAsyncFuture(T updatedData) {
    updateAsync(updatedData);
    return getAsync();
  }

  // @override
  // void emit(S state, {bool temporary = false}) {
  //   if (_lastActiveState == null) {
  //     // set initial state
  //     _lastActiveState = this.state;
  //   }

  //   if (!temporary) {
  //     _lastActiveState = state;
  //   }

  //   super.emit(state);
  // }

  // S getPreviousState(S? temporaryState) {
  //   if (identical(temporaryState, state)) {
  //     return lastActiveState;
  //   } else {
  //     return state;
  //   }
  // }
}
