import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search functionality with list manipulation methods.
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
/// class MyNetworkSearchableListCubit
///     extends NetworkSearchableListCubit<Note, MyState> {
///   MyNetworkSearchableListCubit()
///       : super(
///         const MyState(
///           data: [],
///           visibleData: [],
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
///   // MUST be overridden when extending [NetworkSearchableListCubit] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListCubit] to perform search asynchronously.
///   @override
///   Future<List<Note>> onSearchAsync(String query) {
///     return Future.value(state.data
///         .where((element) => element.message.contains(query))
///         .toList());
///   }
///
///   // Needs to be overridden when extending [NetworkSearchableListCubit] in order to `search` method to work.
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
///   // Can optionally be overridden when extending [NetworkSearchableListCubit] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     final itemToAdd =
///         newItem.copyWith(message: 'Item async note ${newItem.id}');
///     return Future.value(itemToAdd);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListCubit] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     final itemToEdit =
///         updatedItem.copyWith(message: 'Edited note ${updatedItem.id}');
///     return Future.value(itemToEdit);
///   }
///
///   // Can optionally be overridden when extending [NetworkSearchableListCubit] to remove an item asynchronously.
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
/// /// The [onAddItemAsync] is invoked when [addItemAsync] method is called from the UI.
///```dart
/// TextButton(
///   onPressed: () => context.read<MyNetworkSearchableCubit>().addItemAsync(
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
///       .read<MyNetworkSearchableCubit>()
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
///                 .read<MyNetworkSearchableCubit>()
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
///                 .read<MyNetworkSearchableCubit>()
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
///                 .read<MyNetworkSearchableCubit>()
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
///                 .read<MyNetworkSearchableCubit>()
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
///  onChanged: context.read<MyNetworkSearchableCubit>().searchAsync,
/// ),
/// ```
///
/// The [search] method is used to search the data with the provided query.
/// ```dart
/// TextField(
///  onChanged: context.read<MyNetworkSearchableCubit>().search,
/// ),
/// ```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// TextButton(
///     onPressed: () =>
///         context.read<MyNetworkSearchableCubit>().updateAsync([
///           Note(1, 'New note async update'),
///         ]),
///     child: const Text('Update data async')),
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///     onPressed: () => context.read<MyNetworkSearchableCubit>().update([
///           Note(1, 'New note update'),
///         ]),
///     child: const Text('Update data')),
/// ```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkSearchableCubit()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
abstract class NetworkSearchableListCubit<T,
        S extends NetworkSearchableListState<T>> extends NetworkListCubit<T, S>
    with NetworkSearchableBaseMixin<List<T>, S> {
  NetworkSearchableListCubit(super.initialState);
}
