part of 'index.dart';

abstract class NetworkExtraStateBase<T, E> extends NetworkStateBase<T> {
  E get extraData;

  @override
  NetworkExtraStateBase<T, E> copyWithLoading();

  @override
  NetworkExtraStateBase<T, E> copyWithSuccess(
    T data, {
    E? extraData,
    DataChangeReason reason = DataChangeReason.none,
  });

  @override
  NetworkExtraStateBase<T, E> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]);

  @override
  NetworkExtraStateBase<T, E> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
    E? extraData,
  });
}
