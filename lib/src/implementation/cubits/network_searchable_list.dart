import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networksearchablelistcubit}
/// A utility class that combines search functionality with list management.
///
/// The [onLoadAsync] and [equals] MUST be overridden when extending [NetworkSearchableListCubit]. Also, to perform [search] or [searchAsync] the [onStateChanged] must also be overridden.
///```dart
/// class Note {
///   const Note(this.id, this.message);
///
///   final int id;
///   final String message;
/// }
/// /// In the state specify <Note> instead of List<Note>.
/// typedef MyListState = NetworkSearchableListState<Note>;
///
/// class MySearchableListCubit extends NetworkSearchableListCubit<Note, MyListState> {
///   MySearchableListCubit()
///      : super(
///           const MyListState(
///             data: [],
///             visibleData: [],
///           ),
///         );
///
///   @override
///   Future<List<Note>> onLoadAsync() async {
///    return someRepository.fetchData();
///   }
///
///   @override
///   MyListState onStateChanged(DataChangeReason reason, MyListState state) {
///     final query = state.query;
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
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item2.id;
///   }
/// }
///```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MySearchableListCubit>().load();
/// ```
///
///
/// To trigger [search]/[searchAsync] from the UI when the text changes.
/// Example usage:
/// ```dart
/// TextField(
///   onChanged: context.read<MySearchableCubit>().search,
/// ),
/// ```
/// Note: When working with `BlocBuilder`, the`state.visibleData` should be used.
///
///  For example:
///```dart
/// BlocBuilder<MyNetworkSearchableCubit, MyState>(
///   builder: (context, state) {
///     return ListView.builder(
///       itemCount: state.visibleData.length,
///       itemBuilder: (context, index) {
///         final item = state.visibleData[index];
///         return Text(item);
///       },
///     );
///   },
/// );
///```
///
/// The `<T>` in [NetworkSearchableListState] represents the type of data that [NetworkSearchableListCubit] holds. Only the data type needs to be specified, not a `List<T>`.
///
/// {@endtemplate}
abstract class NetworkSearchableListCubit<T,
        S extends NetworkSearchableListState<T>> extends NetworkListCubit<T, S>
    with NetworkSearchableBaseMixin<List<T>, S> {
  /// {@macro networksearchablelistcubit}
  NetworkSearchableListCubit(super.initialState);
}
