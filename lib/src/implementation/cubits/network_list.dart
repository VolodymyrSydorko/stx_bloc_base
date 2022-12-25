import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkListCubit<T, S extends NetworkListState<T>>
    extends NetworkCubit<List<T>, S> with NetworkListBaseMixin<T, S> {
  NetworkListCubit(super.initialState);
}
