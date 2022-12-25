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
    super.errorMessage,
  });

  @override
  NetworkFilterableState<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
    F? filter,
    String? errorMessage,
  }) {
    return NetworkFilterableState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [...super.props, filter];
}
