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
  none,
  loaded,
  extraLoaded,
  updated,
  itemAdded,
  itemEdited,
  itemRemoved,
  searched,
  filtered;

  bool get isNone => this == none;
  bool get isLoaded => this == loaded;
  bool get isExtraLoaded => this == extraLoaded;
  bool get isUpdated => this == updated;
  bool get isItemAdded => this == itemAdded;
  bool get isItemEdited => this == itemEdited;
  bool get isItemRemoved => this == itemRemoved;
  bool get isSearched => this == searched;
  bool get isFiltered => this == filtered;
}

enum FailureReason {
  none,
  load,
  loadExtra,
  update,
  addItem,
  editItem,
  removeItem,
  search,
  filter;

  bool get isNone => this == none;
  bool get isLoad => this == load;
  bool get isLoadExtra => this == loadExtra;
  bool get isUpdate => this == update;
  bool get isAddItem => this == addItem;
  bool get isEditItem => this == editItem;
  bool get isRemoveItem => this == removeItem;
  bool get isSearch => this == search;
  bool get isFilter => this == filter;
}
