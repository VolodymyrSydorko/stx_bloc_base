import 'package:bloc/bloc.dart';
import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that extends [Bloc] to facilitate working with asynchronous data. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
/// ```dart
/// // The state contains the `data` of any type in this case `int` and `status` (NetworkStatus), which is by default [NetworkStatus.initial].
/// typedef MyState = NetworkState<int>;
///
/// class MyNetworkBloc extends NetworkBloc<int, MyState> {
///   MyNetworkBloc() : super(const MyState(data: 0));
///
///   // MUST be overridden when extending [NetworkBloc].
///   @override
///   Future<int> onLoadAsync() async {
///     return Future.value(Random().nextInt(100));
///   }
///
///   // Can optionally be overridden when extending [NetworkBloc].
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
///   create: (context) => MyNetworkBloc()..load(),
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
///     context.read<MyNetworkBloc>().updateAsync(1);
///   },
///   child: Text('Update Data'),
/// )
/// ```
/// The [update] method is used to update the state with the new data.
/// ```dart
/// // This will update the data with the new value.
/// TextButton(
///   onPressed: () {
///     context.read<MyNetworkBloc>().update(Random().nextInt(100));
///   },
///   child: Text('Update Data'),
/// )
/// ```
///
abstract class NetworkBloc<T, S extends NetworkState<T>>
    extends Bloc<NetworkEventBase, S>
    with NetworkBaseMixin<T, S>, NetworkBlocMixin<T, S> {
  NetworkBloc(super.initialState) {
    super.network();
  }
}
