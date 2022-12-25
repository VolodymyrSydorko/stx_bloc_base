import 'package:bloc/bloc.dart';

import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

abstract class NetworkCubit<T, S extends NetworkState<T>> extends Cubit<S>
    with NetworkBaseMixin<T, S> {
  NetworkCubit(super.initialState);
}
