part of 'index.dart';

abstract class NetworkSearchableStateBase<T> extends NetworkStateBase<T> {
  T get visibleData;
  String? get query;

  @override
  NetworkSearchableStateBase<T> copyWith({
    NetworkStatus? status,
    T? data,
    T? visibleData,
    String? query,
    String? errorMessage,
  });
}
