part of 'index.dart';

class NetworkFilterableState<T, F> extends NetworkSearchableState<T>
    implements NetworkFilterableStateBase<T, F> {
  final F? filter;

  const NetworkFilterableState({
    super.status,
    required super.data,
    required super.visibleData,
    super.query,
    this.filter,
  });

  NetworkFilterableState<T, F> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkFilterableState<T, F> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data, visibleData: data);

  NetworkFilterableState<T, F> copyWithFailure() =>
      copyWith(status: NetworkStatus.failure);

  @override
  NetworkFilterableState<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
    F? filter,
  }) {
    return NetworkFilterableState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [...super.props, filter];
}
