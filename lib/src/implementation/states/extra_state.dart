part of 'index.dart';

class NetworkExtraState<T, E> extends NetworkState<T>
    implements NetworkExtraStateBase<T, E> {
  final E extraData;

  const NetworkExtraState({
    super.status,
    required super.data,
    required this.extraData,
    super.errorMessage,
  });

  @override
  NetworkExtraState<T, E> copyWithSuccess(T data, [E? extraData]) =>
      copyWith(status: NetworkStatus.success, data: data, extraData: extraData);

  @override
  NetworkExtraState<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    E? extraData,
    String? errorMessage,
  }) {
    return NetworkExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      extraData: extraData ?? this.extraData,
      errorMessage: errorMessage ?? this.errorMessage,
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
    super.errorMessage,
  });

  @override
  NetworkSearchableExtraState<T, E> copyWithSuccess(T data, [E? extraData]) =>
      copyWith(
        status: NetworkStatus.success,
        data: data,
        visibleData: data,
        extraData: extraData,
      );

  @override
  NetworkSearchableExtraState<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    E? extraData,
    String? query,
    String? errorMessage,
  }) {
    return NetworkSearchableExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      extraData: extraData ?? this.extraData,
      query: query ?? this.query,
      errorMessage: errorMessage ?? this.errorMessage,
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
    super.errorMessage,
  });

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
  NetworkFilterableExtraState<T, F, E> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    E? extraData,
    String? query,
    F? filter,
    String? errorMessage,
  }) {
    return NetworkFilterableExtraState(
      status: status ?? this.status,
      data: data ?? this.data,
      visibleData: visibleData ?? this.visibleData,
      extraData: extraData ?? this.extraData,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
