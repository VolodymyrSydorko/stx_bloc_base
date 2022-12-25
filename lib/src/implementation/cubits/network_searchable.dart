import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkSearchableCubit<T, S extends NetworkSearchableState<T>>
    extends NetworkCubit<T, S> with NetworkSearchableBaseMixin<T, S> {
  NetworkSearchableCubit(super.initialState);
}
