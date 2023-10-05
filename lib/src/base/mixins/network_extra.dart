import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

mixin NetworkExtraBlocMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBlocMixin<T, S>, NetworkExtraBaseMixin<T, E, S> {
  @override
  void network() {
    on<NetworkEventLoadExtraAsync>(onEventLoadExtraAsync);
    on<NetworkEventLoadWithExtraAsync>(onEventLoadWithExtraAsync);
  }

  void loadExtra() => add(NetworkEventLoadExtraAsync());
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

mixin NetworkExtraBaseMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBaseMixin<T, S> {
  FutureOr<void> loadWithExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      final (T data, E extra) = await onLoadWithExtraAsync();

      emit(
        onStateChanged(
          state.copyWithSuccess(
            data,
            extraData: extra,
            reason: DataChangeReason.loaded,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(FailureReason.load) as S);
      addError(e, stackTrace);
    }
  }

  FutureOr<void> loadExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      var extraData = await onLoadExtraAsync();

      emit(
        onStateChanged(
          state.copyWith(
            status: NetworkStatus.success,
            extraData: extraData,
            changeReason: DataChangeReason.extraLoaded,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(FailureReason.loadExtra) as S);
      addError(e, stackTrace);
    }
  }

  @override
  Future<T> onLoadAsync() {
    throw UnimplementedError();
  }

  Future<(T data, E extra)> onLoadWithExtraAsync() async {
    return (await onLoadAsync(), await onLoadExtraAsync());
  }

  Future<E> onLoadExtraAsync() {
    throw UnimplementedError();
  }

  Future<S> loadWithExtraAsyncFuture() {
    loadWithExtra();

    return getAsync();
  }

  Future<S> loadExtraAsyncFuture() {
    loadExtra();
    return getAsync();
  }
}
