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
  void updateAsync(T updatedData) => add(NetworkEventUpdateAsync(updatedData));

  @protected
  Future<void> onEventLoadAsync(
    NetworkEventLoadAsync event,
    Emitter<NetworkStateBase<T>> emit,
  ) async {
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

mixin NetworkBaseMixin<T, S extends NetworkStateBase<T>> on BlocBase<S> {
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

  FutureOr<void> update(T updatedData) {
    emit(
      onStateChanged(
        DataChangeReason.updated,
        state.copyWithSuccess(updatedData) as S,
      ),
    );
  }

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

  Future<T> onLoadAsync();

  Future<T> onUpdateAsync(T updatedData) => Future.value(updatedData);

  S onStateChanged(DataChangeReason reason, S state) =>
      state.copyWith(status: NetworkStatus.success) as S;

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
}
