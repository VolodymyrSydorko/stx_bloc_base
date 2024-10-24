import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with manipulation methods. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
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
/// // In the state, specify the data type directly, such as <Note>, instead of using <List<Note>>. The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input, and `query` is used to store the user's search input.
/// typedef MyState = NetworkSearchableListState<Note>;
///
/// class MyNetworkSearchableListBloc
///     extends NetworkSearchableListBloc<Note, MyState> {
///   MyNetworkSearchableListBloc()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
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
///   // MUST be overridden when extending [NetworkSearchableListBloc] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListBloc] to perform search asynchronously.
///   @override
///   Future<List<Note>> onSearchAsync(String query) {
///     return Future.value(state.data
///         .where((element) => element.message.contains(query))
///         .toList());
///   }
///
///   // Needs to be overridden when extending [NetworkSearchableListBloc] in order to `search` method to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     final query = state.query;
///
///     var visibleData = state.data;
///
///     if (query != null && query.isNotEmpty) {
///       visibleData =
///           visibleData.where((note) => note.message.contains(query)).toList();
///     }
///
///     return state.copyWith(visibleData: visibleData);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListBloc] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     final itemToAdd =
///         newItem.copyWith(message: 'Item async note ${newItem.id}');
///     return Future.value(itemToAdd);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListBloc] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     final itemToEdit =
///         updatedItem.copyWith(message: 'Edited note ${updatedItem.id}');
///     return Future.value(itemToEdit);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListBloc] to remove an item asynchronously.
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
///   onPressed: () => context.read<MyNetworkSearchableBloc>().addItemAsync(
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
///       .read<MyNetworkSearchableBloc>()
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
///                 .read<MyNetworkSearchableBloc>()
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
///                 .read<MyNetworkSearchableBloc>()
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
///                 .read<MyNetworkSearchableBloc>()
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
///                 .read<MyNetworkSearchableBloc>()
///                 .removeItemA(item),
///             child: const Text('Remove item'),
///           ),
///        ],
///   ),
/// );
/// ```
///
/// The [onSearchAsync] is invoked when [searchAsync] method is called from the UI.
/// ```dart
/// TextField(
///  onChanged: context.read<MyNetworkSearchableBloc>().searchAsync,
/// ),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// TextField(
///  onChanged: context.read<MyNetworkSearchableBloc>().search,
/// ),
/// ```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// TextButton(
///     onPressed: () =>
///         context.read<MyNetworkSearchableBloc>().updateAsync([
///           Note(1, 'New note async update'),
///         ]),
///     child: const Text('Update data async')),
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///     onPressed: () => context.read<MyNetworkSearchableBloc>().update([
///           Note(1, 'New note update'),
///         ]),
///     child: const Text('Update data')),
/// ```
///
abstract class NetworkSearchableListBloc<T,
        S extends NetworkSearchableListState<T>> extends NetworkListBloc<T, S>
    with
        NetworkSearchableBaseMixin<List<T>, S>,
        NetworkSearchableBlocMixin<List<T>, S> {
  NetworkSearchableListBloc(super.initialState) {
    super.network();
  }
}
