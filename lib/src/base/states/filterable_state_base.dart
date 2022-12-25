part of 'index.dart';

abstract class NetworkFilterableStateBase<T, F> extends NetworkStateBase<T> {
  T get visibleData;
  F? get filter;

  @override
  NetworkFilterableStateBase<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    F? filter,
    String? errorMessage,
  });
}
