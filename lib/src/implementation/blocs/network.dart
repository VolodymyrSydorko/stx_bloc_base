import 'package:bloc/bloc.dart';
import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkbloc}
/// A [NetworkBloc] is an extension of [Bloc] to facilitate working with asynchronous data.
///
/// Like [NetworkCubit], it shares the same methods as[load], [update], and [updateAsync].
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
/// The key idea behind [NetworkBloc] (and its descendants) is to have the ability to use the [Bloc] in a similar way to  [Cubit]. By calling the provided methods, it internally adds [NetworkEventLoadAsync], [NetworkEventUpdate], [NetworkEventUpdateAsync] events to [Bloc]).
///
/// ```dart
/// context.read<MyNetworkBloc>().load();
/// ```
///
/// This is achieved by invoking the [network] method from the [NetworkBlocMixin] when [NetworkBloc] is instantiated.
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
