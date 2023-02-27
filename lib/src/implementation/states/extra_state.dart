part of 'index.dart';

class NetworkExtraState<T, E> extends NetworkState<T>
    implements NetworkExtraStateBase<T, E> {
  final E extraData;

  const NetworkExtraState({
    super.status,
    required super.data,
    required this.extraData,
  });

  @override
  NetworkExtraState<T, E> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkExtraState<T, E> copyWithSuccess(T data, [E? extraData]) =>
      copyWith(status: NetworkStatus.success, data: data, extraData: extraData);

  @override
  NetworkExtraState<T, E> copyWithFailure() =>
      copyWith(status: NetworkStatus.failure);

  @override
  NetworkExtraState<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    E? extraData,
  }) {
    return NetworkExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  List<Object?> get props => [...super.props, extraData];
}

class NetworkSearchableExtraState<T, E> extends NetworkSearchableState<T>
    implements NetworkExtraStateBase<T, E> {
  final E extraData;

  const NetworkSearchableExtraState({
    super.status,
    required super.data,
    required super.visibleData,
    required this.extraData,
    super.query,
  });

  @override
  NetworkSearchableExtraState<T, E> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkSearchableExtraState<T, E> copyWithSuccess(T data, [E? extraData]) =>
      copyWith(
        status: NetworkStatus.success,
        data: data,
        visibleData: data,
        extraData: extraData,
      );

  @override
  NetworkSearchableExtraState<T, E> copyWithFailure() =>
      copyWith(status: NetworkStatus.failure);

  @override
  NetworkSearchableExtraState<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    E? extraData,
    String? query,
  }) {
    return NetworkSearchableExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      extraData: extraData ?? this.extraData,
      query: query ?? this.query,
    );
  }
}

class NetworkFilterableExtraState<T, F, E> extends NetworkFilterableState<T, F>
    implements NetworkExtraStateBase<T, E> {
  final E extraData;

  const NetworkFilterableExtraState({
    super.status,
    required super.data,
    required super.visibleData,
    required this.extraData,
    super.query,
    super.filter,
  });

  @override
  NetworkFilterableExtraState<T, F, E> copyWithLoading() =>
      copyWith(status: NetworkStatus.loading);

  @override
  NetworkFilterableExtraState<T, F, E> copyWithSuccess(T data,
          [E? extraData]) =>
      copyWith(
        status: NetworkStatus.success,
        data: data,
        visibleData: data,
        extraData: extraData,
      );

  @override
  NetworkFilterableExtraState<T, F, E> copyWithFailure() =>
      copyWith(status: NetworkStatus.failure);

  @override
  NetworkFilterableExtraState<T, F, E> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    E? extraData,
    String? query,
    F? filter,
  }) {
    return NetworkFilterableExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      extraData: extraData ?? this.extraData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
    );
  }
}
