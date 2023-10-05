part of 'index.dart';

class NetworkState<T> extends Equatable implements NetworkStateBase<T> {
  final NetworkStatus status;

  final DataChangeReason changeReason;
  final FailureReason failureReason;

  final T data;

  const NetworkState({
    this.status = NetworkStatus.initial,
    this.changeReason = DataChangeReason.none,
    this.failureReason = FailureReason.none,
    required this.data,
  });

  NetworkState<T> copyWithLoading() => copyWith(status: NetworkStatus.loading);

  NetworkState<T> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  }) =>
      copyWith(
        status: NetworkStatus.success,
        changeReason: reason,
        data: data,
      );

  NetworkState<T> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]) =>
      copyWith(
        status: NetworkStatus.failure,
        failureReason: reason,
      );

  NetworkState<T> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
  }) {
    return NetworkState(
      status: status ?? this.status,
      changeReason: changeReason ?? this.changeReason,
      failureReason: failureReason ?? this.failureReason,
      data: data ?? this.data,
    );
  }

  String get errorMsg => status.isFailure ? 'Something went wrong' : '';

  @override
  List<Object?> get props => [status, data];
}
