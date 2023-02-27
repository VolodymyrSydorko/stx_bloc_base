part of 'index.dart';

class NetworkSearchableState<T> extends NetworkState<T>
    implements NetworkSearchableStateBase<T> {
  final T visibleData;
  final String? query;

  const NetworkSearchableState({
    super.status,
    required super.data,
    required this.visibleData,
    this.query,
  });

  @override
  NetworkSearchableState<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data, visibleData: data);

  @override
  NetworkSearchableState<T> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
  }) {
    return NetworkSearchableState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [...super.props, visibleData, query];
}
