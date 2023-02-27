part of 'index.dart';

abstract class NetworkExtraStateBase<T, E> extends NetworkStateBase<T> {
  E get extraData;

  @override
  NetworkExtraStateBase<T, E> copyWithLoading();

  @override
  NetworkExtraStateBase<T, E> copyWithSuccess(T data, [E? extraData]);

  @override
  NetworkExtraStateBase<T, E> copyWithFailure();

  @override
  NetworkExtraStateBase<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    E? extraData,
  });
}
