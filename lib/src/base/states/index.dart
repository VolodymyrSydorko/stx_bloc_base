library states;

import 'package:stx_bloc_base/src/base/models/models.dart';
import 'package:stx_bloc_base/src/implementation/states/index.dart';

part 'state_base.dart';
part 'extra_state.dart';
part 'searchable_state_base.dart';
part 'filterable_state_base.dart';

/// Simplifies the use of [NetworkStateBase] when working with a `List`.
///
/// Is used in conjunction with [NetworkListBlocMixin].
typedef NetworkListStateBase<T> = NetworkStateBase<List<T>>;
