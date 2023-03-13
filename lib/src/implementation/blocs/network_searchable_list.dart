import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkSearchableListBloc<T,
        S extends NetworkSearchableListState<T>> extends NetworkListBloc<T, S>
    with
        NetworkSearchableBaseMixin<List<T>, S>,
        NetworkSearchableBlocMixin<List<T>, S> {
  NetworkSearchableListBloc(super.initialState) {
    super.network();
  }
}
