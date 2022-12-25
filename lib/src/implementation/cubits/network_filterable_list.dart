import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkFilterableListCubit<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListCubit<T, S>
    with NetworkFilterableBaseMixin<List<T>, F, S> {
  NetworkFilterableListCubit(super.initialState);
}
