part of 'index.dart';

class NetworkState<T> extends Equatable implements NetworkStateBase<T> {
  final NetworkStatus status;
  final T data;
  final String? errorMessage;

  const NetworkState({
    this.status = NetworkStatus.initial,
    required this.data,
    this.errorMessage,
  });

  NetworkState<T> copyWithLoading() => copyWith(status: NetworkStatus.loading);

  NetworkState<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data);

  NetworkState<T> copyWithFailure([String? errorMessage]) =>
      copyWith(status: NetworkStatus.failure, errorMessage: errorMessage);

  NetworkState<T> copyWith({
    NetworkStatus? status,
    T? data,
    String? errorMessage,
  }) {
    return NetworkState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get errorMsg =>
      status.isFailure ? errorMessage ?? 'Something went wrong' : '';

  @override
  List<Object?> get props => [status, data, errorMessage];
}
