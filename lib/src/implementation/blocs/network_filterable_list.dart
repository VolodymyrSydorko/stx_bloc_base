import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// A utility class that combines search and filtering functionality with list manipulation methods. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///Example usage:
///
///```dart
/// enum Filter {
///   even,
///   odd;
///
///   bool get isEven => this == Filter.even;
///   bool get isOdd => this == Filter.odd;
/// }
///
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
/// // Here `Filter` is used to filter the data by `id`. Any type can be used here, for example, `bool`, `int`, `String`, enum, etc.
/// typedef MyState = NetworkFilterableListState<Note, Filter>;
/// // In the state, specify the data type directly, such as <Note>, instead of using <List<Note>>. The state contains the `data` of any type in this case `List<Note>` and `status` (NetworkStatus), which is by default [NetworkStatus.initial], `visibleData` will be used to display the data in the UI based on the user's search input, and `query` is used to store the user's search input and `filter` is used to store the user's filter input.
///
/// class MyNetworkFilterableListBloc
///     extends NetworkFilterableListBloc<Note, Filter, MyState> {
///   MyNetworkFilterableListBloc()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );
///
///   // MUST be overridden when extending [NetworkListBloc].
///   @override
///   Future<List<Note>> onLoadAsync() async {
///     return Future.value(List.generate(10, (index) {
///       return Note(index + 1, 'Note ${index + 1}');
///     }));
///   }
///
///   // MUST be overridden when extending [NetworkFilterableListBloc] as it is essential for data mutation operations.
///   // Typically positioned at the end of all method overrides.
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc] to perform search asynchronously.
///   @override
///   Future<List<Note>> onSearchAsync(String query) {
///     return Future.value(state.data
///         .where((element) => element.message.contains(query))
///         .toList());
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc] to perform filtering asynchronously.
///   @override
///   Future<List<Note>> onFilterAsync(Filter filter) {
///     return Future.value(state.data
///         .where(
///             (element) => filter.isEven ? element.id.isEven : element.id.isOdd)
///         .toList());
///   }
///
///   // Needs to be overridden when extending [NetworkFilterableListBloc] in order to `search` and `filter` methods to work.
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///     final query = state.query;
///     final filter = state.filter;
///
///     var visibleData = state.data;
///
///     if (query != null && query.isNotEmpty) {
///       visibleData =
///           visibleData.where((note) => note.message.contains(query)).toList();
///     }
///
///     if (filter != null) {
///       visibleData = visibleData
///           .where((note) => filter.isEven ? note.id.isEven : note.id.isOdd)
///           .toList();
///     }
///
///     return state.copyWith(visibleData: visibleData);
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc] to add new item asynchronously.
///   @override
///   Future<Note> onAddItemAsync(Note newItem) async {
///     final itemToAdd =
///         newItem.copyWith(message: 'Item async note ${newItem.id}');
///     return Future.value(itemToAdd);
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc] to edit an item asynchronously.
///   @override
///   Future<Note> onEditItemAsync(Note updatedItem) {
///     final itemToEdit =
///         updatedItem.copyWith(message: 'Edited note ${updatedItem.id}');
///     return Future.value(itemToEdit);
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc] to remove an item asynchronously.
///   // Only items with even ids can be removed.
///   @override
///   Future<bool> onRemoveItemAsync(Note removedItem) {
///     if (removedItem.id.isEven) {
///       return Future.value(true);
///     }
///     return Future.value(false);
///   }
///
///   // Can optionally be overridden when extending [NetworkFilterableListBloc].
///   @override
///   Future<List<Note>> onUpdateAsync(updatedData) {
///     return Future.value([
///       ...updatedData,
///       ...state.data,
///     ]);
///   }
/// }
/// ```
///  The [onAddItemAsync] is invoked when [addItemAsync] method is called from the UI.
///```dart
/// TextButton(
///   onPressed: () => context.read<MyNetworkFilterableListBloc>().addItemAsync(
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
///       .read<MyNetworkFilterableListBloc>()
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
///                 .read<MyNetworkFilterableListBloc>()
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
///                 .read<MyNetworkFilterableListBloc>()
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
///                 .read<MyNetworkFilterableListBloc>()
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
///                 .read<MyNetworkFilterableListBloc>()
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
///  onChanged: context.read<MyNetworkFilterableListBloc>().searchAsync,
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
/// The [onFilterAsync] is invoked when [filterAsync] method is called from the UI.
/// ```dart
/// TextButton(
///  onPressed: () => context.read<MyNetworkFilterableListBloc>().filterAsync(Filter.even),
/// child: const Text('Filter even'),
/// ),
/// ```
/// The [filter] method is used to filter the data with the provided filter.
/// ```dart
/// TextButton(
/// onPressed: () => context.read<MyNetworkFilterableListBloc>().filter(Filter.odd),
/// child: const Text('Filter odd'),
/// ),
/// ```
///
/// The [onUpdateAsync] is invoked when [updateAsync] method is called from the UI.
/// ```dart
/// TextButton(
///     onPressed: () =>
///         context.read<MyNetworkFilterableListBloc>().updateAsync([
///           Note(1, 'New note async update'),
///         ]),
///     child: const Text('Update data async')),
/// ```
///
/// The [update] method is used to update the state with the new data.
/// ```dart
/// TextButton(
///     onPressed: () => context.read<MyNetworkFilterableListBloc>().update([
///           Note(1, 'New note update'),
///         ]),
///     child: const Text('Update data')),
/// ```
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// BlocProvider(
///   create: (context) => MyNetworkFilterableListBloc()..load(),
///   child: {
///     // Your widget here
///   },
/// )
/// ```
///
abstract class NetworkFilterableListBloc<T, F,
        S extends NetworkFilterableListState<T, F>>
    extends NetworkSearchableListBloc<T, S>
    with
        NetworkFilterableBaseMixin<List<T>, F, S>,
        NetworkFilterableBlocMixin<List<T>, F, S> {
  NetworkFilterableListBloc(super.initialState) {
    super.network();
  }
}
