library states;

import 'package:stx_bloc_base/src/base/models/models.dart';

part 'state_base.dart';
part 'extra_state.dart';
part 'searchable_state_base.dart';
part 'filterable_state_base.dart';

typedef NetworkListStateBase<T> = NetworkStateBase<List<T>>;
typedef NetworkSearchableListStateBase<T> = NetworkSearchableStateBase<List<T>>;
typedef NetworkFilterableListStateBase<T, F>
    = NetworkFilterableStateBase<List<T>, F>;
