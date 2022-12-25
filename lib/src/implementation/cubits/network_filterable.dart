import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkFilterableCubit<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableCubit<T, S>
    with NetworkFilterableBaseMixin<T, F, S> {
  NetworkFilterableCubit(super.initialState);
}
