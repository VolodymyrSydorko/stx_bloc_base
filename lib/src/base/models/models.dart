import 'index.dart';

/// Represents the various network statuses.
enum NetworkStatus {
  /// [initial] is passed to the [NetworkState] constructor.
  initial,

  /// [loading] is passed to the [NetworkState.copyWithLoading] method.
  loading,

  /// [success] is passed to the [NetworkState.copyWithSuccess] method.
  success,

  /// [failure] is passed to the [NetworkState.copyWithFailure] method.
  failure;

  bool get isInitial => this == initial;
  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isFailure => this == failure;
}

/// The [AddPosition] specifies where to add the item in the list.
enum AddPosition {
  /// [start] specifies whether to add the item at the start of the `List`.
  start,

  /// [end] specifies whether to add the item at the end of the `List`.
  end;

  bool get isStart => this == AddPosition.start;
  bool get isEnd => this == AddPosition.end;
}

/// Passed as an argument to [NetworkBaseMixin.onStateChanged] method.
enum DataChangeReason {
  loaded,
  extraLoaded,
  updated,
  itemAdded,
  itemEdited,
  itemRemoved,
  searched,
  filtered;

  bool get isLoaded => this == loaded;
  bool get isExtraLoaded => this == extraLoaded;
  bool get isUpdated => this == updated;
  bool get isItemAdded => this == itemAdded;
  bool get isItemEdited => this == itemEdited;
  bool get isItemRemoved => this == itemRemoved;
  bool get isSearched => this == searched;
  bool get isFiltered => this == filtered;
}
