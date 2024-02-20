import '../models/models.dart';

abstract class NetworkEventBase {}

class NetworkEventLoadAsync implements NetworkEventBase {}

class NetworkEventLoadWithExtraAsync implements NetworkEventBase {}

class NetworkEventLoadExtraAsync implements NetworkEventBase {}

class NetworkEventUpdate<T> implements NetworkEventBase {
  final T updatedData;

  const NetworkEventUpdate(this.updatedData);
}

class NetworkEventUpdateAsync<T> implements NetworkEventBase {
  final T updatedData;
  final bool force;

  const NetworkEventUpdateAsync(
    this.updatedData, {
    this.force = true,
  });
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
  final bool force;

  NetworkEventAddItemAsync(
    this.newItem, {
    this.position = AddPosition.end,
    this.force = true,
  });
}

class NetworkEventEditItem<T> implements NetworkEventBase {
  final T updatedItem;

  NetworkEventEditItem(this.updatedItem);
}

class NetworkEventEditItemAsync<T> implements NetworkEventBase {
  final T updatedItem;
  final bool force;

  NetworkEventEditItemAsync(
    this.updatedItem, {
    this.force = true,
  });
}

class NetworkEventRemoveItem<T> implements NetworkEventBase {
  final T item;

  NetworkEventRemoveItem(this.item);
}

class NetworkEventRemoveItemAsync<T> implements NetworkEventBase {
  final T item;
  final bool force;

  NetworkEventRemoveItemAsync(
    this.item, {
    this.force = true,
  });
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
