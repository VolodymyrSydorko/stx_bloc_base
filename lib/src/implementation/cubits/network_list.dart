import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that simplifies working with asynchronous `List` data.
///
/// Example usage:
///
/// ```dart
/// class Note {
///   Note(this.id, this.message);
///
///   final int id;
///   final String message;
///
///   Note copyWith({int? id, String? message}) {
///     return Note(id ?? this.id, message ?? this.message);
///   }
/// }
///
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
///     return Future.value(List.generate(10, (index) {
///       return Note(index + 1, 'Note ${index + 1}');
///     }));
///   }
///
///   // MUST be overridden when extending [NetworkListCubit] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     final itemToAdd =
///         newItem.copyWith(message: 'Item async note ${newItem.id}');
///     return Future.value(itemToAdd);
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     final itemToEdit =
///         updatedItem.copyWith(message: 'Edited note ${updatedItem.id}');
///     return Future.value(itemToEdit);
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit] to remove an item asynchronously.
///   // Only items with even ids can be removed.
///   @override
///   Future<bool> onRemoveItemAsync(Note removedItem) {
///     if (removedItem.id.isEven) {
///       return Future.value(true);
///     }
///     return Future.value(false);
///   }
///
///   // Can optionally be overridden when extending [NetworkListCubit].
///   @override
///   Future<List<Note>> onUpdateAsync(updatedData) {
///     return Future.value([
///       ...updatedData,
///       ...state.data,
///     ]);
///   }
/// }
/// ```
/// The [onAddItemAsync] is invoked when [addItemAsync] method is called from the UI.
///```dart
/// TextButton(
///   onPressed: () => context.read<MyNetworkListCubit>().addItemAsync(
///     // The AddPosition is optional and defaults to [AddPosition.end].
///     // If [AddPosition.start] is used, the new item will be added at the beginning of the list, otherwise at the end.
///     Note(1, 'New note async append'),
///     AddPosition.start,
///   ),
///   child: const Text('Append item async'),
/// ),
/// ```
///
/// The [addItem] method is used to add a new item to the list.
/// ```dart
/// TextButton(
///   onPressed: () => context
///       .read<MyNetworkListCubit>()
///       .addItem(Note(1, 'New note append')),
///   child: const Text('Append item'),
/// ),
/// ```
/// The [onEditItemAsync] is invoked when [editItemAsync] method is called from the UI.
/// ```dart
/// ListView.builder(
///   itemCount: state.data.length,
///   itemBuilder: (context, index) {
///     final item = state.data[index];
///     return ListTile(
///       title: Row(
///         children: [
///           Text(item.message),
///           TextButton(
///             onPressed: () => context
///                 .read<MyNetworkListCubit>()
///                 .editItemAsync(item),
///             child: const Text('Edit item async'),
///           ),
///        ],
///     ),
///  );
/// },
/// ```
///
/// The [editItem] method is used to edit an item in the list.
/// ```dart
/// ListView.builder(
///   itemCount: state.data.length,
///   itemBuilder: (context, index) {
///     final item = state.data[index];
///     return ListTile(
///       title: Row(
///         children: [
///           TextButton(
///             onPressed: () => context
///                 .read<MyNetworkListCubit>()
///                 .editItem(
///                   item.copyWith(
///                       message: 'Edited item'),
///                 ),
///             child: const Text('Edit item'),
///           ),
///        ],
///    ),
///  );
/// },
/// ```
/// The [onRemoveItemAsync] is invoked when [removeItemAsync] method is called from the UI.
/// ```dart
/// ListView.builder(
///   itemCount: state.data.length,
///   itemBuilder: (context, index) {
///     final item = state.data[index];
///     return ListTile(
///       title: Row(
///         children: [
///           TextButton(
///             onPressed: () => context
///                 .read<MyNetworkListCubit>()
///                 .removeItemAsync(item),
///             child: const Text('Remove item async'),
///           ),
///        ],
///   ),
/// );
/// ```
///
/// The [removeItem] method is used to remove an item from the list.
/// ListView.builder(
///   itemCount: state.data.length,
///   itemBuilder: (context, index) {
///     final item = state.data[index];
///     return ListTile(
///       title: Row(
///         children: [
///           TextButton(
///             onPressed: () => context
///                 .read<MyNetworkListCubit>()
///                 .removeItemA(item),
///             child: const Text('Remove item'),
///           ),
///        ],
///   ),
/// );
/// ```
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// TextButton(
///     onPressed: () =>
///         context.read<MyNetworkListCubit>().updateAsync([
///           Note(1, 'New note async update'),
///         ]),
///     child: const Text('Update data async')),
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///     onPressed: () => context.read<MyNetworkListCubit>().update([
///           Note(1, 'New note update'),
///         ]),
///     child: const Text('Update data')),
/// ```
///
/// The [onLoadAsync] is invoked when [loadAsync] method is called from the UI.
/// ```dart
/// BlocProvider(
///  create: (context) => MyNetworkListCubit()..loadAsync(),
/// child: {
/// // Your widget here
/// },
/// )
/// ```
///
abstract class NetworkListCubit<T, S extends NetworkListState<T>>
    extends NetworkCubit<List<T>, S> with NetworkListBaseMixin<T, S> {
  NetworkListCubit(super.initialState);
}
