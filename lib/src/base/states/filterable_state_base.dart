part of 'index.dart';

abstract class NetworkFilterableStateBase<T, F> extends NetworkStateBase<T> {
  T get visibleData;
  F? get filter;

  NetworkFilterableStateBase<T, F> copyWithLoading();

  NetworkFilterableStateBase<T, F> copyWithSuccess(T data);

  NetworkFilterableStateBase<T, F> copyWithFailure();

  @override
  NetworkFilterableStateBase<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    F? filter,
  });
}
