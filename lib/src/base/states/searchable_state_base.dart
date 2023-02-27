part of 'index.dart';

abstract class NetworkSearchableStateBase<T> extends NetworkStateBase<T> {
  T get visibleData;
  String? get query;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(T data);

  NetworkStateBase<T> copyWithFailure();

  @override
  NetworkSearchableStateBase<T> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
  });
}
