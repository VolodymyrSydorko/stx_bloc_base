import 'package:bloc/bloc.dart';
import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkbloc}
/// A utility class that extends [Bloc] to facilitate working with asynchronous data. Like [NetworkCubit], it shares the same methods as [load], [update], and [updateAsync].
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
/// The key idea behind [NetworkBloc] (and its descendants) is to provide functionality similar to [Cubit], allowing specific events to be added by calling the provided methods: when [load], [update], [updateAsync] are called, the corresponding [NetworkEventLoadAsync], [NetworkEventUpdate], or [NetworkEventUpdateAsync] are added internally to the [Bloc]).
///
/// This is achieved by invoking the [network] method from the [NetworkBlocMixin] when [NetworkBloc] is instantiated.
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// context.read<MyNetworkBloc>().load();
/// ```
///
/// The [NetworkState] is managed by [NetworkBloc]. The `<T>` in the [NetworkState] represents datatype that [NetworkState] holds.
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
