library states;

import 'package:equatable/equatable.dart';
import 'package:stx_bloc_base/src/base/index.dart';

part 'network_state.dart';
part 'extra_state.dart';
part 'searchable_state.dart';
part 'filterable_state.dart';

/// A `state.data` of the [NetworkListCubit] and [NetworkListBloc] represented as a `List`.
typedef NetworkListState<T> = NetworkState<List<T>>;

/// A `state.data` of the [NetworkSearchableListCubit] and [NetworkSearchableListBloc] represented as a `List` and search [query].
typedef NetworkSearchableListState<T> = NetworkSearchableState<List<T>>;

/// A `state.data` of the [NetworkFilterableListCubit] and [NetworkFilterableListBloc] represented as a `List` with a [filter] and search [query].
typedef NetworkFilterableListState<T, F> = NetworkFilterableState<List<T>, F>;

/// A `state.data` which is used in conjunction with [NetworkExtraBlocMixin] and [NetworkExtraBaseMixin] represented as a `List` and [extraData].
typedef NetworkExtraListState<T, E> = NetworkExtraState<List<T>, E>;

/// A `state.data` which is used in conjunction with [NetworkExtraBlocMixin] and [NetworkExtraBaseMixin] represented as a `List` and [extraData] with a search [query].
typedef NetworkSearchableExtraListState<T, E>
    = NetworkSearchableExtraState<List<T>, E>;

/// A `state.data` which is used in conjunction with [NetworkExtraBlocMixin] and [NetworkExtraBaseMixin] represented as a `List` and [extraData] with a [filter] and search [query].
typedef NetworkFilterableExtraListState<T, F, E>
    = NetworkFilterableExtraState<List<T>, F, E>;
