part of 'index.dart';

/// Is an interface class which serves as a base for the [NetworkExtraState].
///
/// Inherits [data] and [status] from the [NetworkStateBase], and provides the new [extraData] property.
///
abstract class NetworkExtraStateBase<T, E> extends NetworkStateBase<T> {
  E get extraData;

  @override
  NetworkExtraStateBase<T, E> copyWithLoading();

  @override
  NetworkExtraStateBase<T, E> copyWithSuccess(T data, [E? extraData]);

  @override
  NetworkExtraStateBase<T, E> copyWithFailure();

  @override
  NetworkExtraStateBase<T, E> copyWith({
    NetworkStatus? status,
    T? data,
    E? extraData,
  });
}
