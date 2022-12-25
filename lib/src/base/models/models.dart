enum NetworkStatus {
  initial,
  loading,
  success,
  failure;

  bool get isInitial => this == initial;
  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

enum AddPosition {
  start,
  end;

  bool get isStart => this == AddPosition.start;
  bool get isEnd => this == AddPosition.end;
}

enum DataChangeReason {
  loaded,
  updated,
  itemAdded,
  itemEdited,
  itemRemoved,
  searched,
  filtered;

  bool get isLoaded => this == loaded;
  bool get isUpdated => this == updated;
  bool get isItemAdded => this == itemAdded;
  bool get isItemEdited => this == itemEdited;
  bool get isItemRemoved => this == itemRemoved;
  bool get isSearched => this == searched;
  bool get isFiltered => this == filtered;
}
