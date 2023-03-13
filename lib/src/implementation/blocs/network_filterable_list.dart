import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkFilterableListBloc<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListBloc<T, S>
    with
        NetworkFilterableBaseMixin<List<T>, F, S>,
        NetworkFilterableBlocMixin<List<T>, F, S> {
  NetworkFilterableListBloc(super.initialState) {
    super.network();
  }
}
