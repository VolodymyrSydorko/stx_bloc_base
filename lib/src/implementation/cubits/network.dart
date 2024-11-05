import 'package:bloc/bloc.dart';

import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that extends [Cubit] to facilitate working with asynchronous data.
///
/// Example usage:
///
/// ```dart
/// // The state contains the `data` of any type in this case `int` and `status` (NetworkStatus), which is by default [NetworkStatus.initial].
/// typedef MyState = NetworkState<int>;
///
/// class MyNetworkCubit extends NetworkCubit<int, MyState> {
///   MyNetworkCubit() : super(const MyState(data: 0));
///
///   // MUST be overridden when extending [NetworkCubit].
///   @override
///   Future<int> onLoadAsync() async {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkCubit].
///   @override
///   Future<int> onUpdateAsync(updatedData) async {
///     // ...
///   }
/// }
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// CubitProvider(
///   create: (context) => MyNetworkCubit()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkCubit>().updateAsync(/* updatedData */);
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// context.read<MyNetworkCubit>().update(/* updatedData */);
/// ```
///
abstract class NetworkCubit<T, S extends NetworkState<T>> extends Cubit<S>
    with NetworkBaseMixin<T, S> {
  NetworkCubit(super.initialState);
}
