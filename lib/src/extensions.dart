import 'package:stx_bloc_base/stx_bloc_base.dart';

extension NetworkBaseBlocX<T, S extends NetworkStateBase<T>>
    on NetworkBlocBase<T, S> {
  Future<S> getAsync() {
    return stream.firstWhere((state) => !state.status.isLoading);
  }

  Future<S> loadAsyncFuture() async {
    load();
    return getAsync();
  }

  Future<S> updateAsyncFuture(T updatedData) async {
    updateAsync(updatedData);
    return getAsync();
  }
}

extension NetworkListBlocX<T, S extends NetworkListState<T>>
    on NetworkListBloc<T, S> {
  Future<S> addItemAsyncFuture(T newItem) async {
    addItemAsync(newItem);
    return getAsync();
  }

  Future<S> editItemAsyncFuture(T updatedItem) async {
    editItemAsync(updatedItem);
    return getAsync();
  }

  Future<S> removeItemAsyncFuture(T item) async {
    removeItemAsync(item);
    return getAsync();
  }
}

extension NetworkSearchableBlocX<T, S extends NetworkSearchableState<T>>
    on NetworkSearchableBloc<T, S> {
  Future<S> searchAsyncFuture(String query) async {
    searchAsync(query);
    return getAsync();
  }
}

extension NetworkFilterableBlocX<T, F, S extends NetworkFilterableState<T, F>>
    on NetworkFilterableBloc<T, F, S> {
  Future<S> filterAsyncFuture(F filter) async {
    filterAsync(filter);
    return getAsync();
  }
}
