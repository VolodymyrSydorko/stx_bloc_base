part of 'index.dart';

abstract class NetworkStateBase<T> {
  NetworkStatus get status;

  DataChangeReason get changeReason;
  FailureReason get failureReason;

  T get data;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  });

  NetworkStateBase<T> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]);

  NetworkStateBase<T> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
  });
}
