part of 'index.dart';

class NetworkSearchableState<T> extends NetworkState<T>
    implements NetworkSearchableStateBase<T> {
  final T visibleData;
  final String? query;

  const NetworkSearchableState({
    super.status,
    super.changeReason,
    super.failureReason,
    required super.data,
    required this.visibleData,
    this.query,
  });

  NetworkSearchableState<T> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkSearchableState<T> copyWithSuccess(
    T data, {
    DataChangeReason reason = DataChangeReason.none,
  }) =>
      copyWith(
        status: NetworkStatus.success,
        changeReason: reason,
        data: data,
        visibleData: data,
      );

  NetworkSearchableState<T> copyWithFailure([
    FailureReason reason = FailureReason.none,
  ]) =>
      copyWith(
        status: NetworkStatus.failure,
        failureReason: reason,
      );

  @override
  NetworkSearchableState<T> copyWith({
    NetworkStatus? status,
    DataChangeReason? changeReason,
    FailureReason? failureReason,
    T? data,
    T? visibleData,
    String? query,
  }) {
    return NetworkSearchableState(
      status: status ?? this.status,
      changeReason: changeReason ?? this.changeReason,
      failureReason: failureReason ?? this.failureReason,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [...super.props, visibleData, query];
}
