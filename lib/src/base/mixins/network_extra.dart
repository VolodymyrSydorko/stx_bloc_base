import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../index.dart';

/// Extends the functionality of [NetworkBlocMixin] by adding [loadExtra] and [loadWithExtra] convenience methods. It inherits [load], [update], and [updateAsync] from [NetworkBlocMixin].
///
/// Does not have implementation of it's own [Bloc], so it can be mixed in to any of the existing implementations which holds the [NetworkExtraState] and its' descendants as a `state`.
///
/// Each method overrides its corresponding method in [NetworkExtraBaseMixin] and, when called, adds the respective event to the [Bloc].
///
/// After adding the event, the event handler invokes this method implementation from [NetworkExtraBaseMixin].

mixin NetworkExtraBlocMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBlocMixin<T, S>, NetworkExtraBaseMixin<T, E, S> {
  /// Must be called `super.network()` when [Bloc] with NetworkExtraBlocMixin is instantiated.
  /// ```dart
  /// class MyNetworkFilterableListWithExtraBloc
  ///     extends NetworkFilterableListBloc<Note, Filter, MyState>
  ///     with NetworkExtraBaseMixin, NetworkExtraBlocMixin {
  ///   MyNetworkFilterableListWithExtraBloc()
  ///       : super(
  ///           const MyState(data: [], visibleData: [], extraData: 0),
  ///         ) {
  ///     super.network();
  ///   }
  /// ```
  @override
  void network() {
    on<NetworkEventLoadExtraAsync>(onEventLoadExtraAsync);
    on<NetworkEventLoadWithExtraAsync>(onEventLoadWithExtraAsync);
  }

  /// [loadExtra] method of the [NetworkExtraBlocMixin] overrides the [NetworkExtraBaseMixin.loadExtra] and add the [NetworkEventLoadExtraAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadExtraAsync] calls the the [NetworkExtraBaseMixin.loadExtra] which invokes [loadExtra] internally.
  @override
  void loadExtra() => add(NetworkEventLoadExtraAsync());

  /// [loadWithExtra] method of the [NetworkExtraBlocMixin] overrides the [NetworkExtraBaseMixin.loadWithExtra] and add the [NetworkEventLoadWithExtraAsync] to the [Bloc] event queue.
  ///
  /// When the event is added, the [onEventLoadWithExtraAsync] calls the the [NetworkExtraBaseMixin.loadWithExtra] which invokes [loadWithExtra] internally.
  @override
  void loadWithExtra() => add(NetworkEventLoadWithExtraAsync());

  @protected
  FutureOr<void> onEventLoadExtraAsync(NetworkEventLoadExtraAsync event,
      Emitter<NetworkExtraStateBase<T, E>> emit) {
    return super.loadExtra();
  }

  @protected
  FutureOr<void> onEventLoadWithExtraAsync(NetworkEventLoadWithExtraAsync event,
      Emitter<NetworkExtraStateBase<T, E>> emit) {
    return super.loadWithExtra();
  }
}

/// Utility mixin that can be mixed in to any of the existing implementations of [Bloc]/[Cubit] which holds the [NetworkExtraState] and its' descendants as a `state`. Does not have implementation of it's own [Bloc]/[Cubit]. Provides the implementation of [loadWithExtra] and [loadExtra] methods.
///
mixin NetworkExtraBaseMixin<T, E, S extends NetworkExtraStateBase<T, E>>
    on NetworkBaseMixin<T, S> {
  /// Use [loadWithExtra] to fetch data with an extra data. Combines the [load] and [loadExtra] methods.
  ///
  /// The [onLoadWithExtraAsync] is invoked when [loadWithExtra] method is called from the UI.
  FutureOr<void> loadWithExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      var data = await onLoadWithExtraAsync();

      emit(
        onStateChanged(
          DataChangeReason.loaded,
          state.copyWithSuccess(data.$1, data.$2) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// The [onLoadExtraAsync] is invoked when [loadExtra] method is called from the UI.
  /// ```dart
  /// BlocProvider(
  ///   create: (context) => MyNetworkFilterableListCubit()..loadExtra(),
  ///   child: {
  ///     // Your widget here
  ///   },
  /// )
  ///
  FutureOr<void> loadExtra() async {
    emit(state.copyWithLoading() as S);

    try {
      var extraData = await onLoadExtraAsync();

      emit(
        onStateChanged(
          DataChangeReason.extraLoaded,
          state.copyWith(
            status: NetworkStatus.success,
            extraData: extraData,
          ) as S,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWithFailure() as S);
      addError(e, stackTrace);
    }
  }

  /// Unlike other [Cubit]/[Bloc] that uses [NetworkBlocMixin], the [onLoadAsync] can optionally be overridden when extending [Cubit]/[Bloc] with [NetworkExtraBaseMixin] to fetch the data.
  ///
  ///```dart
  /// @override
  /// Future<List<Note>> onLoadAsync() async {
  ///   return Future.value(List.generate(10, (index) {
  ///     return Note(index + 1, 'Note ${index + 1}');
  ///   }));
  /// }
  ///```
  ///
  /// The [onLoadAsync] is invoked when [load] method is called from the UI.
  /// ```dart
  /// BlocProvider(
  ///   create: (context) => MyNetworkFilterableListCubit()..load(),
  ///   child: {
  ///     // Your widget here
  ///   },
  /// )
  ///
  @override
  Future<T> onLoadAsync() {
    throw UnimplementedError();
  }

  /// Can optionally be overridden when extending any [Bloc]/[Cubit] with [NetworkExtraBaseMixin] to fetch the extra data.
  ///
  /// Override example:
  /// ```dart
  /// @override
  /// Future<int> onLoadExtraAsync() async {
  ///  return Future.value(10);
  /// }
  /// ```
  ///
  Future<E> onLoadExtraAsync() {
    throw UnimplementedError();
  }

  /// Can optionally be overridden when extending any [Bloc]/[Cubit] with [NetworkExtraBaseMixin] to fetch data with an extra data.
  ///
  /// If the [onLoadAsync] and [onLoadExtraAsync] have its own implementation, this method can be left unimplemented. In this case it will internally call the [onLoadAsync] and [onLoadWithExtraAsync] and return the result of both methods. In this case the [onLoadWithExtraAsync] is invoked when [loadWithExtra] is called from the UI and can be used in the similar way as [load].

  /// In addition, a custom implementation can be provided here without overriding the [onLoadAsync] and [onLoadExtraAsync]. In this case the [loadWithExtra] must be called from the UI.
  /// ```dart
  /// @override
  /// Future<(List<Note>, int)> onLoadWithExtraAsync() {
  ///   final listOfNotes = List.generate(10, (index) {
  ///     return Note(index + 1, 'Note ${index + 1}');
  ///   });
  ///   return Future.value((listOfNotes, 5));
  /// }
  /// ```
  ///
  Future<(T data, E extra)> onLoadWithExtraAsync() async {
    return (await onLoadAsync(), await onLoadExtraAsync());
  }

  // Additional methods
  /// Is a helper method that [loadWithExtra] first, then returns the first `state` if the [NetworkStatus] is **not** `loading`.
  Future<S> loadWithExtraAsyncFuture() {
    loadWithExtra();
    return getAsync();
  }

  /// Is a helper method that [loadExtra] first, then returns the first `state` if the [NetworkStatus] is **not** `loading`.
  Future<S> loadExtraAsyncFuture() {
    loadExtra();
    return getAsync();
  }
}
