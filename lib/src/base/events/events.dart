import '../models/models.dart';
import '../mixins/index.dart';

/// Is an abstract class which is served as a base class for other events implementations.
///
abstract class NetworkEventBase {}

/// Is an event which is used by [NetworkBlocMixin.load] to perform  fetching data asynchronously.
///
class NetworkEventLoadAsync implements NetworkEventBase {}

class NetworkEventLoadWithExtraAsync implements NetworkEventBase {}

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

class NetworkEventAddItem<T> implements NetworkEventBase {
  NetworkEventAddItem(
    this.newItem, {
    this.position = AddPosition.end,
  });

  final T newItem;
  final AddPosition position;
}

class NetworkEventAddItemAsync<T> implements NetworkEventBase {
  final T newItem;
  final AddPosition position;

  NetworkEventAddItemAsync(
    this.newItem, [
    this.position = AddPosition.end,
  ]);
}

class NetworkEventEditItem<T> implements NetworkEventBase {
  final T updatedItem;

  NetworkEventEditItem(this.updatedItem);
}

class NetworkEventEditItemAsync<T> implements NetworkEventBase {
  final T updatedItem;

  NetworkEventEditItemAsync(this.updatedItem);
}

class NetworkEventRemoveItem<T> implements NetworkEventBase {
  final T item;

  NetworkEventRemoveItem(this.item);
}

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

class NetworkEventFilter<F> implements NetworkEventBase {
  final F filter;

  NetworkEventFilter(this.filter);
}

class NetworkEventFilterAsync<F> implements NetworkEventBase {
  final F filter;

  NetworkEventFilterAsync(this.filter);
}
