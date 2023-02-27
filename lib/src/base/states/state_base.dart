part of 'index.dart';

abstract class NetworkStateBase<T> {
  NetworkStatus get status;
  T get data;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(T data);

  NetworkStateBase<T> copyWithFailure();

  NetworkStateBase<T> copyWith({NetworkStatus? status, T? data});
}
