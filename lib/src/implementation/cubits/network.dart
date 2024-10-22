import 'package:bloc/bloc.dart';

import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that extends [Cubit] to facilitate working with asynchronous data.
///
/// Example usage:
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
///     return Future.value(Random().nextInt(100));
///   }
///
///   // Can optionally be overridden when extending [NetworkCubit] to update data asynchronously.
///   @override
///   Future<int> onUpdateAsync(updatedData) async {
///     return Future.value(state.data + updatedData);
///   }
/// }
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkCubit()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// // This will increment the data by 1.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkCubit>().updateAsync(1);
///   },
///   child: Text('Update Data'),
/// )
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// // This will replace the data with the new value.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkCubit>().update(Random().nextInt(100));
///   },
///   child: Text('Update Data'),
/// )
/// ```
///
abstract class NetworkCubit<T, S extends NetworkState<T>> extends Cubit<S>
    with NetworkBaseMixin<T, S> {
  NetworkCubit(super.initialState);
}
