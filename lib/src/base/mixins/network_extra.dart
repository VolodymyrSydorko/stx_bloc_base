import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

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
      var data = await onLoadWithExtraAsync();

      emit(
        onStateChanged(
          DataChangeReason.loaded,
          state.copyWithSuccess(data.item1, data.item2) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

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

  @override
  Future<T> onLoadAsync() {
    throw UnimplementedError();
  }

  Future<Tuple2<T, E>> onLoadWithExtraAsync() async {
    return Tuple2(await onLoadAsync(), await onLoadExtraAsync());
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
