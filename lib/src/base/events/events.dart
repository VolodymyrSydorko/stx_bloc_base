import '../models/models.dart';

abstract class NetworkEventBase {}

class NetworkEventLoadAsync implements NetworkEventBase {}

class NetworkEventUpdate<T> implements NetworkEventBase {
  final T updatedData;

  const NetworkEventUpdate(this.updatedData);
}

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

class NetworkEventSearch implements NetworkEventBase {
  final String query;

  NetworkEventSearch(this.query);
}

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
