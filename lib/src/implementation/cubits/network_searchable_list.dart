import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkSearchableListCubit<T,
        S extends NetworkSearchableListState<T>> extends NetworkListCubit<T, S>
    with NetworkSearchableBaseMixin<List<T>, S> {
  NetworkSearchableListCubit(super.initialState);
}
