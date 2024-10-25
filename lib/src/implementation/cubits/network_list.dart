import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous `List` data.
///
/// Example usage:
///
/// ```dart
/// // In the state, specify the data type directly, such as <Note>, instead of using <List<Note>>. The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial].
/// typedef MyState = NetworkListState<Note>;
///
/// class MyNetworkListCubit extends NetworkListCubit<Note, MyState> {
///   MyNetworkListCubit()
///       : super(
///         const MyState(
///           data: [],
///         ),
///       );
///
///   // MUST be overridden when extending [NetworkListCubit].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///    // ...
///   }
///
///   // MUST be overridden when extending [NetworkListCubit] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     // ...
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to remove an item asynchronously.
///   @override
///   Future<bool> onRemoveItemAsync(Note removedItem) {
///     // ...
///   }
///
/// ```
/// The [onAddItemAsync] is invoked when [addItemAsync] method is called from the UI.
///```dart
/// context.read<MyNetworkListCubit>().addItemAsync( /* item */, AddPosition.start
///     // If [AddPosition.start] is used, the new item will be added at the beginning of the list, otherwise at the end.
///   ),
/// ```
///
/// The [addItem] method is used to add a new item to the list.
/// ```dart
/// context.read<MyNetworkListCubit>().addItem(/* item */),
/// ```
/// The [onEditItemAsync] is invoked when [editItemAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkListCubit>().editItemAsync(/* item */),
/// ```
///
/// The [editItem] method is used to edit an item in the list.
/// ```dart
/// context.read<MyNetworkListCubit>().editItem(/* item */),
/// ```
/// The [onRemoveItemAsync] is invoked when [removeItemAsync] method is called from the UI.
/// ```dart
/// context.read<MyNetworkListCubit>().removeItemAsync(/* item */),
/// ```
///
/// The [removeItem] method is used to remove an item from the list.
/// ```dart
/// context.read<MyNetworkListCubit>().removeItem(/* item */),
/// ```
///
abstract class NetworkListCubit<T, S extends NetworkListState<T>>
    extends NetworkCubit<List<T>, S> with NetworkListBaseMixin<T, S> {
  NetworkListCubit(super.initialState);
}
