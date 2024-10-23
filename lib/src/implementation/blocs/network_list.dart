import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';
import 'package:bloc/bloc.dart';

/// A utility class that simplifies working with asynchronous `List` data. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
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
///     return Future.value(List.generate(10, (index) {
///       return Note(index + 1, 'Note ${index + 1}');
///     }));
///   }
///
///   // MUST be overridden when extending [NetworkListBloc] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     final itemToAdd =
///         newItem.copyWith(message: 'Item async note ${newItem.id}');
///     return Future.value(itemToAdd);
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     final itemToEdit =
///         updatedItem.copyWith(message: 'Edited note ${updatedItem.id}');
///     return Future.value(itemToEdit);
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc] to remove an item asynchronously.
///   // Only items with even ids can be removed.
///   @override
///   Future<bool> onRemoveItemAsync(Note removedItem) {
///     if (removedItem.id.isEven) {
///       return Future.value(true);
///     }
///     return Future.value(false);
///   }
///
///   // Can optionally be overridden when extending [NetworkListBloc].
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
///   onPressed: () => context.read<MyNetworkListBloc>().addItemAsync(
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
///       .read<MyNetworkListBloc>()
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
///                 .read<MyNetworkListBloc>()
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
///                 .read<MyNetworkListBloc>()
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
///                 .read<MyNetworkLisBloc>()
///                 .removeItemAsync(item),
///             child: const Text('Remove item async'),
///           ),
///        ],
///   ),
/// );
/// ```
///
/// The [removeItem] method is used to remove an item from the list.
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
///                 .read<MyNetworkListBloc>()
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
///         context.read<MyNetworkListBloc>().updateAsync([
///           Note(1, 'New note async update'),
///         ]),
///     child: const Text('Update data async')),
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///     onPressed: () => context.read<MyNetworkListBloc>().update([
///           Note(1, 'New note update'),
///         ]),
///     child: const Text('Update data')),
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkListBLoc()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
abstract class NetworkListBloc<T, S extends NetworkListState<T>>
    extends NetworkBloc<List<T>, S>
    with NetworkListBaseMixin<T, S>, NetworkListBlocMixin<T, S> {
  NetworkListBloc(super.initialState) {
    super.network();
  }
}
