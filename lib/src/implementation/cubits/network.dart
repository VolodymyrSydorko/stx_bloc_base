import 'package:bloc/bloc.dart';

import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkcubit}
/// A utility class that extends [Cubit] to facilitate working with asynchronous data.
///
/// The [onLoadAsync] MUST be overridden when extending [NetworkCubit].
///
/// ```dart
/// typedef MyDataState = NetworkState<Data>;
///
/// class MyNetworkCubit extends NetworkCubit<Data, MyDataState> {
///   MyNetworkCubit(super.initialState);
///
///   @override
///   Future<Data> onLoadAsync() async {
///     return someRepository.fetchData();
///   }
/// }
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MyNetworkCubit>().load();
/// ```
///
/// The `<T>` in the [NetworkState] represents datatype that [NetworkCubit] holds.
///
/// {@endtemplate}
abstract class NetworkCubit<T, S extends NetworkState<T>> extends Cubit<S>
    with NetworkBaseMixin<T, S> {
  /// {@macro networkcubit}
  NetworkCubit(super.initialState);
}
