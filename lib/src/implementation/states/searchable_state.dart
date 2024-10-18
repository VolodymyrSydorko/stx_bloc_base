part of 'index.dart';

/// Is a `state` of the [NetworkSearchableCubit] and [NetworkSearchableBloc].
///
class NetworkSearchableState<T> extends NetworkState<T>
    implements NetworkSearchableStateBase<T> {
  /// Holds the data of type `T`, that will be displayed on the UI based on the user's search input [query].
  final T visibleData;

  /// The search query itself.
  final String? query;

  const NetworkSearchableState({
    super.status,
    required super.data,
    required this.visibleData,
    this.query,
  });

  NetworkSearchableState<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkSearchableState<T> copyWithSuccess(T data) =>
      copyWith(status: NetworkStatus.success, data: data, visibleData: data);

  NetworkSearchableState<T> copyWithFailure() =>
      copyWith(status: NetworkStatus.failure);

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
