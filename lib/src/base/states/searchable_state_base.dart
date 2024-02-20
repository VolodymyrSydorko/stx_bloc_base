part of 'index.dart';

abstract class NetworkSearchableStateBase<T> extends NetworkStateBase<T> {
  T get visibleData;
  String? get query;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  });

  NetworkStateBase<T> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]);

  @override
  NetworkSearchableStateBase<T> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
    T? visibleData,
    String? query,
  });
}
