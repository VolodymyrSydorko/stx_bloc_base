part of 'index.dart';

/// [NetworkStateBase] is an interface class which serves as a base for the [NetworkState].
///
/// It provides several `copyWith` methods, which are implemented in the [NetworkState]
abstract class NetworkStateBase<T> {
  /// Indicates the current network [status].
  NetworkStatus get status;

  /// Holds the actual [data] of type `T`, where `T` is a generic type.
  T get data;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(T data);

  NetworkStateBase<T> copyWithFailure();

  NetworkStateBase<T> copyWith({NetworkStatus? status, T? data});
}
