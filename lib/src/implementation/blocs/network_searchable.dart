import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkSearchableBloc<T, S extends NetworkSearchableState<T>>
    extends NetworkBloc<T, S>
    with NetworkSearchableBaseMixin<T, S>, NetworkSearchableBlocMixin<T, S> {
  NetworkSearchableBloc(super.initialState) {
    super.network();
  }
}
