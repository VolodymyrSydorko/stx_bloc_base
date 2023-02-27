part of 'index.dart';

class NetworkState<T> extends Equatable implements NetworkStateBase<T> {
  final NetworkStatus status;
  final T data;

  const NetworkState({
    this.status = NetworkStatus.initial,
    required this.data,
  });

  NetworkState<T> copyWithLoading() => copyWith(status: NetworkStatus.loading);

  NetworkState<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data);

  NetworkState<T> copyWithFailure() => copyWith(status: NetworkStatus.failure);

  NetworkState<T> copyWith({
    NetworkStatus? status,
    T? data,
  }) {
    return NetworkState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  String get errorMsg => status.isFailure ? 'Something went wrong' : '';

  @override
  List<Object?> get props => [status, data];
}
