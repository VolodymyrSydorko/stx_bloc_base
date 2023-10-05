part of 'index.dart';

class NetworkFilterableState<T, F> extends NetworkSearchableState<T>
    implements NetworkFilterableStateBase<T, F> {
  final F? filter;

  const NetworkFilterableState({
    super.status,
    super.changeReason,
    super.failureReason,
    required super.data,
    required super.visibleData,
    super.query,
    this.filter,
  });

  NetworkFilterableState<T, F> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkFilterableState<T, F> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  }) =>
      copyWith(
        status: NetworkStatus.success,
        changeReason: reason,
        data: data,
        visibleData: data,
      );

  NetworkFilterableState<T, F> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]) =>
      copyWith(
        status: NetworkStatus.failure,
        failureReason: reason,
      );

  @override
  NetworkFilterableState<T, F> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
    T? visibleData,
    String? query,
    F? filter,
  }) {
    return NetworkFilterableState(
      status: status ?? this.status,
      changeReason: changeReason ?? this.changeReason,
      failureReason: failureReason ?? this.failureReason,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [...super.props, filter];
}
