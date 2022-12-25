import 'dart:async';

import 'package:tuple/tuple.dart';

import '../index.dart';

mixin NetworkExtraBaseMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBaseMixin<T, S> {
  @override
  FutureOr<void> load() async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onLoadWithExtraAsync();

      emit(
        onDataChanged(
          DataChangeReason.loaded,
          state.copyWithSuccess(data.item1, data.item2) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure(
          NetworkBaseMixin.errorHandler.onError(e, stackTrace)) as S);
    }
  }

  @override
  Future<T> onLoadAsync() {
    return Future.value();
  }

  Future<Tuple2<T, E>> onLoadWithExtraAsync();
}
