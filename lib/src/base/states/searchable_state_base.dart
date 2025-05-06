part of 'index.dart';

/// Is an interface class which serves as a base for the [NetworkSearchableState].
///
/// Inherits [data] and [status] from the [NetworkStateBase] and provides the new [visibleData] and [query] properties.
///
abstract class NetworkSearchableStateBase<T> extends NetworkStateBase<T> {
  /// Will be displayed on the UI based on the user's search input [query] to separate `visibleData` from the `data`.
  ///
  /// Will be displayed in the UI based on the search [query] to separate `visibleData` from the `data`.
  ///
  T get visibleData;

  /// The search query itself.
  String? get query;

  NetworkStateBase<T> copyWithLoading();

  NetworkStateBase<T> copyWithSuccess(T data);

  NetworkStateBase<T> copyWithFailure();

  @override
  NetworkSearchableStateBase<T> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
  });
}
