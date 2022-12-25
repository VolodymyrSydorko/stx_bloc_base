part of 'index.dart';

abstract class NetworkStateBase<T> {
  NetworkStatus get status;
  T get data;
  String? get errorMessage;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(T data);

  NetworkStateBase<T> copyWithFailure([String? errorMessage]);

  NetworkStateBase<T> copyWith({
    NetworkStatus? status,
    T? data,
    String? errorMessage,
  });
}
