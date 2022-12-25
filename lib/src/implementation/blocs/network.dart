import 'package:bloc/bloc.dart';
import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkBloc<T, S extends NetworkState<T>>
    extends Bloc<NetworkEventBase, S>
    with NetworkBaseMixin<T, S>, NetworkBlocMixin<T, S> {
  NetworkBloc(super.initialState) {
    super.network();
  }
}
