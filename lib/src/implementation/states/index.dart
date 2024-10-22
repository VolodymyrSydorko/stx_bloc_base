library states;

import 'package:equatable/equatable.dart';
import 'package:stx_bloc_base/src/base/index.dart';

part 'network_state.dart';
part 'extra_state.dart';
part 'searchable_state.dart';
part 'filterable_state.dart';

/// A `state` of the [NetworkListCubit] and [NetworkListBloc] represented as a `List`.
typedef NetworkListState<T> = NetworkState<List<T>>;

/// A `state` of the [NetworkSearchableListCubit] and [NetworkSearchableListBloc] represented as a `List`.
typedef NetworkSearchableListState<T> = NetworkSearchableState<List<T>>;

/// A `state` of the [NetworkFilterableListCubit] and [NetworkFilterableListBloc] represented as a `List`.
typedef NetworkFilterableListState<T, F> = NetworkFilterableState<List<T>, F>;

typedef NetworkExtraListState<T, E> = NetworkExtraState<List<T>, E>;
typedef NetworkSearchableExtraListState<T, E>
    = NetworkSearchableExtraState<List<T>, E>;
typedef NetworkFilterableExtraListState<T, F, E>
    = NetworkFilterableExtraState<List<T>, F, E>;
