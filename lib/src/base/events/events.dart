import '../models/models.dart';
import '../mixins/index.dart';

/// Is an abstract class which is served as a base class for other events implementations.
///
abstract class NetworkEventBase {}

/// Is an event which is used by [NetworkBlocMixin.load] to perform fetching data asynchronously.
///
class NetworkEventLoadAsync implements NetworkEventBase {}

/// Is an event which is used by [NetworkExtraBlocMixin.loadWithExtra] to perform fetching data plus extra data asynchronously.
///
class NetworkEventLoadWithExtraAsync implements NetworkEventBase {}

/// Is an event which is used by [NetworkExtraBlocMixin.loadExtra] to perform fetching extra data asynchronously.
///
class NetworkEventLoadExtraAsync implements NetworkEventBase {}

/// Is an event which is used by [NetworkBlocMixin.update] to update the data locally.
///
class NetworkEventUpdate<T> implements NetworkEventBase {
  final T updatedData;

  const NetworkEventUpdate(this.updatedData);
}

/// Is an event which is used by [NetworkBlocMixin.updateAsync] to update the data asynchronously.
///
class NetworkEventUpdateAsync<T> implements NetworkEventBase {
  final T updatedData;

  const NetworkEventUpdateAsync(this.updatedData);
}

/// Is an event which is used by [NetworkListBlocMixin.addItem] to add item to the `List` locally.
///
class NetworkEventAddItem<T> implements NetworkEventBase {
  NetworkEventAddItem(
    this.newItem, {
    this.position = AddPosition.end,
  });

  final T newItem;
  final AddPosition position;
}

/// Is an event which is used by [NetworkListBlocMixin.addItemAsync] to add item to the `List` asynchronously.
///
class NetworkEventAddItemAsync<T> implements NetworkEventBase {
  final T newItem;
  final AddPosition position;

  NetworkEventAddItemAsync(
    this.newItem, [
    this.position = AddPosition.end,
  ]);
}

/// Is an event which is used by [NetworkListBlocMixin.editItem] to edit item in the `List` locally.
///
class NetworkEventEditItem<T> implements NetworkEventBase {
  final T updatedItem;

  NetworkEventEditItem(this.updatedItem);
}

/// Is an event which is used by [NetworkListBlocMixin.editItemAsync] to edit item in the `List` asynchronously.
///
class NetworkEventEditItemAsync<T> implements NetworkEventBase {
  final T updatedItem;

  NetworkEventEditItemAsync(this.updatedItem);
}

/// Is an event which is used by [NetworkListBlocMixin.removeItem] to remove item from the `List` locally.
///
class NetworkEventRemoveItem<T> implements NetworkEventBase {
  final T item;

  NetworkEventRemoveItem(this.item);
}

/// Is an event which is used by [NetworkListBlocMixin.removeItemAsync] to remove item from the `List` asynchronously.
///
class NetworkEventRemoveItemAsync<T> implements NetworkEventBase {
  final T item;

  NetworkEventRemoveItemAsync(this.item);
}

/// Is an event which is used by [NetworkSearchableBlocMixin.search] to search the data locally.
///
class NetworkEventSearch implements NetworkEventBase {
  final String query;

  NetworkEventSearch(this.query);
}

/// Is an event which is used by [NetworkSearchableBlocMixin.searchAsync] to search the data asynchronously.
///
class NetworkEventSearchAsync implements NetworkEventBase {
  final String query;

  NetworkEventSearchAsync(this.query);
}

/// Is an event which is used by [NetworkFilterableBlocMixin.filter] to filter the data locally.
///
class NetworkEventFilter<F> implements NetworkEventBase {
  final F filter;

  NetworkEventFilter(this.filter);
}

/// Is an event which is used by [NetworkFilterableBlocMixin.filterAsync] to filter the data asynchronously.
///
class NetworkEventFilterAsync<F> implements NetworkEventBase {
  final F filter;

  NetworkEventFilterAsync(this.filter);
}
