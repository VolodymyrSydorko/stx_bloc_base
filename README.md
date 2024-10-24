# stx_bloc_base

The package provides various generic implementations of `Cubit`s and `Bloc`s.

---

- [Introduction](#introduction)
  - [Motivation](#motivation)
  - [Installation](#installation)
  - [Quick Start](#quick-start)
  - [Class Hierarchy](#class-hierarchy)
  - [How does it work?](#how-does-it-work)
- [`Bloc`s and `Cubit`s And their Purpose](#blocs-and-cubits-and-their-purpose)  
  - [NetworkCubit/NetworkBloc](#networkcubitnetworkbloc)
    - [Working with a Cubit](#networkcubitnetworkbloc)
    - [What about Bloc?](#what-about-bloc)
  - [NetworkSearchableCubit/NetworkSearchableBloc](#networksearchablecubitnetworksearchablebloc)
  - [NetworkFilterableCubit/NetworkFilterableBloc](#networkfilterablecubitnetworkfilterablebloc)
  - [NetworkListCubit/NetworkListBloc](#networklistcubitnetworklistbloc)
  - [NetworkSearchableListCubit/NetworkSearchableListBloc](#networksearchablelistcubitnetworksearchablelistbloc)
  - [NetworkFilterableListCubit/NetworkFilterableListBloc](#networkfilterablelistcubitnetworkfilterablelistbloc)
- [Extra Mixin](#network-extra-mixins)
- [Useful methods available for overriding](#useful-methods-that-do-not-require-an-override-but-might-be-useful-in-some-cases)
  - [Update](#update-data)
  - [Search](#search-data)
  - [Filtering](#filter-data)
  - [List mutation](#list-mutation)
- [Additional methods](#additional-methods)
- [Examples](#examples)

## Introduction

This package provides a set of utility methods to facilitate the BLoC pattern when working with asynchronous data. It is especially useful for common operations such as data loading, list manipulation, filtering, and searching.

---

### Motivation

Typically, data operations require a lot of boilerplate code to handle reading, writing, updating, and deleting data, especially for list mutation operations, searching, and filtering. This package simplifies these tasks by allowing you to simply call the corresponding method to perform the operation.

Additionally, the main benefit is that it enables you to use `Bloc` classes in a `Cubit`-like manner, while still leveraging the benefits of `Bloc` and its events. Instead of manually adding events to the BLoC, you can perform operations by directly calling methods.

Also, no need to specify the `Event` when extending the `Bloc` - it has already been defined in the base class, unless a custom implementation is needed (see [example](https://github.com/VolodymyrSydorko/stx_bloc_base/tree/master/example/lib/screens/account)).

```dart
// No Event needs to be specified
class MyNetworkBloc extends NetworkBloc<String, NetworkState<String>> {
  MyNetworkBloc() : super(const NetworkState(data: ''));
    // ...
}
```

Simply call the method as you would do with Cubit.

```dart
BlocProvider(
  create: (BuildContext context) => MyNetworkBloc()..load(),
  child: SomeWidget(),
);
```

## How Does It Work?

This is achieved through various `mixin`s that leverage the `Bloc`/`Cubit` functionality and handle all the heavy lifting under the hood.

---

## Installation

```terminal
flutter pub add stx_bloc_base
```

## `Bloc`s and `Cubit`s And Their Purpose

When extending any of the provided classes, only the `onLoadAsync` needs to be overridden. In the case of [NetworkListCubit/NetworkListBloc](#networklistcubitnetworklistbloc) or [NetworkFilterableListCubit/NetworkFilterableListBloc](#networkfilterablelistcubitnetworkfilterablelistbloc), the `equals` must also be overridden (more on this in the corresponding section).

### Class Hierarchy

The class order is structured such that each subsequent class extends the functionality of the previous one. If anything is unclear in a specific class, please refer to the previous class for clarification.

### NetworkCubit/NetworkBloc

The base class for handling data loading and updating, serves as a foundation for all descendant classes.

#### Quick Start

```dart
class MyNetworkCubit extends NetworkCubit<String, NetworkState<String>> {
  // `NetworkState` contains a `data` field of type `T` and a `status` field of type `NetworkStatus`, which is by default [NetworkStatus.initial]
  MyNetworkCubit() : super(const NetworkState(data: ''));

  // MUST be overridden when extending `NetworkCubit`
  // This method is invoked when `load` method is called from the UI
  @override
  Future<String> onLoadAsync() {
    // Perform network request here to fetch data
  }
}
```

Then, to load data, simply call the `load` method.

```dart
BlocProvider(
  create: (BuildContext context) => MyNetworkCubit()..load(),
  child: SomeWidget(),
);
```

___Note:___ For method overrides required by other classes, please refer to the specific class and its override requirements.

Additionally, the `onUpdateAsync` method can be overridden (see [additional methods](#update-data)).  

---

##### What about `Bloc`?

`NetworkBloc` works similarly; just extend `NetworkBloc` instead of `NetworkCubit`.

```dart
// Works in a similar way to NetworkCubit
class MyNetworkBloc extends NetworkBloc<String, NetworkState<String>> {
  MyNetworkCubit() : super(const NetworkState(data: ''));

  @override
  Future<String> onLoadAsync() {
    // ...
  }
}

```

### NetworkSearchableCubit/NetworkSearchableBloc

The class responsible for handling search.

`NetworkSearchableBloc` works similarly: _please refer to [NetworkBloc](#what-about-bloc) example._

```dart
class MyNetworkSearchableCubit extends NetworkSearchableCubit<List<String>,
    NetworkSearchableState<List<String>>> {
  MyNetworkSearchableCubit()
      // `NetworkSearchableState` contains a `data` field of type `T` and a `visibleData` that will be used to display the data in the UI based on the user's search query input
      : super(const NetworkSearchableState(data: [], visibleData: []));

  @override
  Future<List<String>> onLoadAsync() {
    // ...
  }

  // Can optionally be overridden when extending [NetworkSearchableCubit] to perform search on the data on client side.
  @override
  NetworkSearchableState<List<String>> onStateChanged(
      DataChangeReason reason, NetworkSearchableState<List<String>> state) {
    // Your code here to handle state's visibleData based on the search query
  }
}
```

To search data, simply call the `search` method and pass the `query`.

```dart
TextField(
    onChanged: context.read<MyNetworkSearchableCubit>().search,
),
```

Additionally, the `onSearchAsync` method can be overridden (see [additional methods](#search-data)).  

### NetworkFilterableCubit/NetworkFilterableBloc

The class responsible for handling filtering.

`NetworkFilterableBloc` works similarly: _please refer to [NetworkBloc](#what-about-bloc) example._

```dart
class MyNetworkFilterableCubit extends NetworkFilterableCubit<List<String>,
    bool, NetworkFilterableState<List<String>, bool>> {
  MyNetworkFilterableCubit()
      // `NetworkFilterableState` contains a `data` field of type `T` and a `visibleData` that will be used to display the data in the UI based on the user's search query input and a `filter` field of type `F` that will be used to filter the data based on applied filter

      // Filter can be of any type, for example, `bool`, `int`, `String`, enum, etc.
      : super(const NetworkFilterableState(data: [], visibleData: []));

  @override
  Future<List<String>> onLoadAsync() {
    // ...
  }

  @override
  NetworkFilterableState<List<String>, bool> onStateChanged(
      DataChangeReason reason,
      NetworkFilterableState<List<String>, bool> state) {
        // Your code here to handle state's visibleData based on the search query/filter
  }
}
```

Then, to filter data, simply call the `filter` method and pass the filter.

```dart
context.read<MyNetworkFilterableCubit>().filter(/* filter */),
```

Additionally, the `onFilterAsync` method can be overridden (see [additional methods](#filter-data)).

### NetworkListCubit/NetworkListBloc

The class responsible for handling list mutation operations.

`NetworkListBloc` works similarly: _please refer to [NetworkBloc](#what-about-bloc) example._

```dart
class MyNetworkListCubit
    // In the NetworkListState specify not the List<Note> but just Note
    extends NetworkListCubit<Note, NetworkListState<Note>> {
  MyNetworkListCubit() : super(const NetworkListState(data: []));


  @override
  Future<List<Note>> onLoadAsync() {
    // ..
  }

  // MUST be overridden when extending [NetworkListCubit] as it is essential for data mutation operations
  @override
  bool equals(Note item1, Note item2) {
    // Implement the logic here to define how the equality check will be performed
  }
}
```

Most commonly used methods for list mutations on the client side:

```dart
// Adds an item to the list. AddPosition.start is optional and can be used to add the new item at the beginning of the list
context.read<MyNetworkListCubit>().addItem(note, AddPosition.start);
// Edits an item in the list
context.read<MyNetworkListCubit>().editItem(note);
// Removes an item from the list
context.read<MyNetworkListCubit>().removeItem(note);
```

Additionally, the `onAddItemAsync`, `onEditItemAsync`, `onRemoveItemAsync` methods can be overridden (see [additional methods](#list-mutation)).

### NetworkSearchableListCubit/NetworkSearchableListBloc

Combines list mutation operations with searching functionality.

`NetworkSearchableLisBloc` works similarly: _please refer to [NetworkBloc](#what-about-bloc) example._

For an example, please refer to the [NetworkFilterableListCubit/NetworkFilterableListBloc](#networkfilterablelistcubitnetworkfilterablelistbloc), as the examples are the same except for the `filter`.

### NetworkFilterableListCubit/NetworkFilterableListBloc

This is likely the ___most commonly extended class___, as it combines list mutation operations with filtering and searching functionality.

`NetworkFilterableListBloc` works similarly: _please refer to [NetworkBloc](#what-about-bloc) example._

```dart
class MyNetworkFilterableListCubit extends NetworkFilterableListCubit<String,
    bool, NetworkFilterableListState<String, bool>> {
  MyNetworkFilterableListCubit()
      : super(const NetworkFilterableListState(data: [], visibleData: []));

  @override
  Future<List<String>> onLoadAsync() {
    // ...
  }

  @override
  NetworkFilterableListState<String, bool> onStateChanged(
      DataChangeReason reason, NetworkFilterableListState<String, bool> state) {
    // ...
  }

  @override
  bool equals(String item1, String item2) {
    // ...
  }
}
```

### Useful methods that do not require an override but might be useful in some cases

#### Update Data

Override the `onUpdateAsync` method if you need to perform data updates, such as making a network request to update the data. Can be overridden in any `Cubit`/`Bloc`.

```dart
   @override
   Future<T> onUpdateAsync(updatedData) {
     // Perform an action to update the data, such as making a network request to modify the data
   }

  // To trigger this on the UI, call `updateAsync`
  context.read<MyCubit>().updateAsync(/* updatedData */);

  // To update data only on the client side, call the `update`.
  context.read<MyCubit>().update(/* updatedData */);
```

#### Search Data

Override the `onSearchAsync` method if you need to perform a server-side data search. Can be overridden in [NetworkSearchable](#networksearchablecubitnetworksearchablebloc), [NetworkSearchableList](#networksearchablelistcubitnetworksearchablelistbloc) classes.

```dart
   @override
   Future<T> onSearchAsync(String query) {
     // ...
   }

  // To trigger this on the UI, call `searchAsync`
  context.read<MyCubit>().searchAsync(/* query */);
```

#### Filter Data

Override the `onFilterAsync` method if you need to perform a serve-side data filtering. Can be overridden in [NetworkFilterable](#networkfilterablecubitnetworkfilterablebloc), [NetworkFilterableList](#networkfilterablelistcubitnetworkfilterablelistbloc) classes.

```dart
   @override
   Future<T> onFilterAsync(filter) {
     // ...
   }

  // To trigger this on the UI, call `filterAsync`
  context.read<MyCubit>().filterAsync(/* filter */);
```

#### List Mutation

Override the `onAddItemAsync`, `onEditItemAsync`, `onRemoveItemAsync` methods if you need to perform list mutation operations on the server-side. Can be overridden in [NetworkList](#networklistcubitnetworklistbloc), [NetworkSearchableList](#networksearchablelistcubitnetworksearchablelistbloc), [NetworkFilterableList](#networkfilterablelistcubitnetworkfilterablelistbloc) classes.

```dart
   @override
   Future<T> onAddItemAsync(/* item */) {
     // ...
   }

  @override
   Future<T> onAddItemAsync(/* updatedItem */) {
     // ...
   }

  @override
  Future<bool> onRemoveItemAsync(/* removedItem */) {
    // ...
  }

  // To trigger this on the UI, call `addItemAsync`/`updateItemAsync`/`remoteItemAsync`.
  context.read<MyCubit>().addItemAsync(/* item */);
```

## Additional methods

```dart
  // Returns the first `state` if the NetworkStatus is not loading
  getAsync();
  // Loads data first, then returns the result of getAsync
  loadAsyncFuture();
  // If the status is NetworkStatus.initial returns the result of loadAsyncFuture. Otherwise, if it is loading, it returns the result of getAsync. If neither condition is met, it returns the current state
  initLoadAsyncFuture();
  // Updates the data first, then returns the result of getAsync
  updateAsyncFuture(/* updatedData */);
  // Searches the data first, then returns the result of getAsync
  searchAsyncFuture(/* query */);
  // Filters the data first, then returns the result of getAsync
  filterAsyncFuture(/* filter */);
  // Adds/edits/removes the item first, then returns the result of getAsync
  addItemAsyncFuture(/* item */);
  editItemAsyncFuture(/* item */);
  removeItemAsyncFuture(/* item */);
```

  Additional methods that relates to [Extra](#network-extra-mixins)

```dart
  // Loads extra data first, the returns the result of getAsync
  loadExtraAsyncFuture(); 
  // Performs load() and loadWithExtra() first, the returns the result of getAsync
  loadWithExtraAsyncFuture();
```

## Network Extra Mixins

There are 2 mixins available: `NetworkExtraBlocMixin` and `NetworkExtraBaseMixin` that can be mixed into any `Bloc`/`Cubit` which holds the `NetworkExtraState` and its descendants. These mixins provide additional methods to load extra data.

This adds `loadExtra` and `loadWithExtra` convenience methods.

- __loadExtra__: Fetches additional data (extra data) and updates the state with the new extra data
- __loadWithExtra__: Fetches both data and extra data simultaneously and updates the state with both

You need to mix `NetworkExtraBlocMixin` and `NetworkExtraBaseMixin` into an existing Bloc implementation that holds the `NetworkExtraState` and its descendants as a state. For Cubit, just mix `NetworkExtraBaseMixin`.

```dart
// Here, `int` is an extra data
typedef MyState = NetworkFilterableExtraListState<Note, Filter, int>;

// When extending Cubit, just use NetworkExtraBaseMixin
class MyNetworkFilterableListWithExtraBloc
    extends NetworkFilterableListBloc<Note, Filter, MyState>
    with NetworkExtraBaseMixin, NetworkExtraBlocMixin {
  MyNetworkFilterableListWithExtraBloc()
      : super(
          const MyState(data: [], visibleData: [], extraData: 0),
        ) {
    // When extending Bloc class call this super.network();     
    super.network();
  }
  // ...
}
```

## Examples

- [NetworkFilterableListBloc example](https://github.com/VolodymyrSydorko/stx_bloc_base/tree/master/example/lib/screens/notes)
- [NetworkBloc example with custom implementation](https://github.com/VolodymyrSydorko/stx_bloc_base/tree/master/example/lib/screens/account)
