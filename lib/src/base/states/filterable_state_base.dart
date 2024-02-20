part of 'index.dart';

abstract class NetworkFilterableStateBase<T, F> extends NetworkStateBase<T> {
  T get visibleData;
  F? get filter;

  NetworkFilterableStateBase<T, F> copyWithLoading();

  NetworkFilterableStateBase<T, F> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  });

  NetworkFilterableStateBase<T, F> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]);

  @override
  NetworkFilterableStateBase<T, F> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
    T? visibleData,
    F? filter,
  });
}
