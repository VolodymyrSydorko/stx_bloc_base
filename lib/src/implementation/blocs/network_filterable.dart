import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkFilterableBloc<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableBloc<T, S>
    with
        NetworkFilterableBaseMixin<T, F, S>,
        NetworkFilterableBlocMixin<T, F, S> {
  NetworkFilterableBloc(super.initialState) {
    super.network();
  }
}
