import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkListBloc<T, S extends NetworkListState<T>>
    extends NetworkBloc<List<T>, S>
    with NetworkListBaseMixin<T, S>, NetworkListBlocMixin<T, S> {
  NetworkListBloc(super.initialState) {
    super.network();
  }
}
