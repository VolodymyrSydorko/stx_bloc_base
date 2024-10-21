import 'package:bloc/bloc.dart';
import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkbloc}
/// A utility class that extends [Bloc] to facilitate working with asynchronous data. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// The [onLoadAsync] should be to be overridden when extending [NetworkBloc].
///
/// ```dart
/// typedef MyDataState = NetworkState<Data>;
///
/// class MyNetworkBloc extends NetworkBloc<Data, MyDataState> {
///   MyNetworkBloc(super.initialState);
///
///   @override
///   Future<Data> onLoadAsync() async {
///     return someRepository.fetchData();
///   }
/// }
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// context.read<MyNetworkBloc>().load();
/// ```
///
/// The `<T>` in the [NetworkState] represents datatype that [NetworkState] holds.
///
/// {@endtemplate}
abstract class NetworkBloc<T, S extends NetworkState<T>>
    extends Bloc<NetworkEventBase, S>
    with NetworkBaseMixin<T, S>, NetworkBlocMixin<T, S> {
  /// {@macro networkbloc}
  NetworkBloc(super.initialState) {
    super.network();
  }
}
