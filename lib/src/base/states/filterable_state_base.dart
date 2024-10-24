part of 'index.dart';

/// Is an interface class which serves as a base for the [NetworkFilterableState].
///
/// Inherits [data] and [status] from the [NetworkStateBase], and provides the new [visibleData] and [filter] properties.
///
abstract class NetworkFilterableStateBase<T, F> extends NetworkStateBase<T> {
  /// Holds the data of type `T`, that will be displayed in the UI based on the applied [filter].
  ///
  T get visibleData;

  /// The filter itself. This can be any type, such as `bool`, `String`, a custom class, or an `enum`.
  F? get filter;

  NetworkFilterableStateBase<T, F> copyWithLoading();

  NetworkFilterableStateBase<T, F> copyWithSuccess(T data);

  NetworkFilterableStateBase<T, F> copyWithFailure();

  @override
  NetworkFilterableStateBase<T, F> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    F? filter,
  });
}
