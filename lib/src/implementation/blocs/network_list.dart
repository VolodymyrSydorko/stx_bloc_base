import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';
import 'package:bloc/bloc.dart';

/// A utility class that simplifies working with asynchronous `List` data. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// Example usage:
///
/// ```dart
/// // In the state, specify the data type directly, such as <Note>, instead of using <List<Note>>. The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial].
/// typedef MyState = NetworkListState<Note>;
///
/// class MyNetworkListBloc extends NetworkListBloc<Note, MyState> {
///   MyNetworkListBloc()
///       : super(
///         const MyState(
///           data: [],
///         ),
///       );
///
///   // MUST be overridden when extending [NetworkListBloc].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///    // ...
///   }
///
///   // MUST be overridden when extending [NetworkListBloc] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to remove an item asynchronously.
///   @override
///   Future<bool> onRemoveItemAsync(Note removedItem) {
///     // ...
///   }
///
/// ```
/// The [onAddItemAsync] is invoked when [addItemAsync] method is called from the UI.
///```dart
/// context.read<MyNetworkListBloc>().addItemAsync( /* item */, AddPosition.start
///     // If [AddPosition.start] is used, the new item will be added at the beginning of the list, otherwise at the end.
///   ),
/// ```
///
/// The [addItem] method is used to add a new item to the list.
/// ```dart
/// context.read<MyNetworkListBloc>().addItem(/* item */),
/// ```
/// The [onEditItemAsync] is invoked when [editItemAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkListBloc>().editItemAsync(/* item */),
/// ```
///
/// The [editItem] method is used to edit an item in the list.
/// ```dart
/// context.read<MyNetworkListBloc>().editItem(/* item */),
/// ```
/// The [onRemoveItemAsync] is invoked when [removeItemAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkListBloc>().removeItemAsync(/* item */),
/// ```
///
/// The [removeItem] method is used to remove an item from the list.
/// ```dart
/// context.read<MyNetworkListBloc>().removeItem(/* item */),
/// ```
///
abstract class NetworkListBloc<T, S extends NetworkListState<T>>
    extends NetworkBloc<List<T>, S>
    with NetworkListBaseMixin<T, S>, NetworkListBlocMixin<T, S> {
  NetworkListBloc(super.initialState) {
    super.network();
  }
}
