part of 'index.dart';

/// Is an interface class which serves as a base for the [NetworkSearchableState].
///
/// Inherits [data] and [status] from the [NetworkStateBase] and provides the new [visibleData] and [query] properties.
///
abstract class NetworkSearchableStateBase<T> extends NetworkStateBase<T> {
  /// Holds the data of type `T`, that will be displayed on the UI based on the user's search input [query].
  ///
  /// ```dart
  /// BlocBuilder<MyNetworkSearchableBloc, MyNetworkSearchableState<Data>>(
  /// builder: (context, state) {
  ///    return MyWidget(state.visibleData);
  ///   }
  /// );
  /// ```

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
