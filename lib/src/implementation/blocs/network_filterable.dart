import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkfilterablebloc}
/// A utility class that simplifies working with asynchronous data, specifically for filtering. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// The [onLoadAsync] MUST be overridden when extending [NetworkFilterableCubit].
///
/// ```dart
///
/// class Note {
///   const Note(this.id, this.message);
///
///  final int id;
///  final String message;
/// }
/// typedef MyData = List<Note>;
///  // The bool represents the filter type, meaning that the boolean value should be passed to the filter() method.
/// typedef MyState = NetworkFilterableState<MyData, bool>;

/// class MyFilterableBloc extends NetworkFilterableBloc<MyData, bool, MyState> {
///   MyFilterableBloc()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );

///   @override
///   Future<MyData> onLoadAsync() async {
///    return someRepository.fetchData();
///   }
/// }
/// ```
//
///
/// Trigger [filter]/[filterAsync] from the UI example usage:
/// ```dart
/// TextButton(
///   onPressed: () => context.read<MyFilterableBloc>().filter(true),
///   child: const Text('By even numbers'),
/// ),
/// ```
/// To perform [filter] or [filterAsync] the [onStateChanged] needs to be overridden.
///```dart
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///   final filter = state.filter;
///   var visibleData = state.data;
///
///   if (filter != null) {
///     visibleData = visibleData
///         .where(
///           (note) => filter ? note.id.isEven : note.id.isOdd,
///         )
///         .toList();
///   }
///   return state.copyWith(visibleData: visibleData);
/// }
///```
/// To perform [search]/[searchAsync] the [onStateChanged] override can be adjusted to handle both filtered and searched data.
///```dart
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///   final filter = state.filter;
///   final query = state.query;
///
///   var visibleData = state.data;
///
///   if (query != null && query.isNotEmpty) {
///     visibleData = visibleData
///         .where(
///           (note) => note.message.contains(query),
///         )
///         .toList();
///   }
///
///   if (filter != null) {
///     visibleData = visibleData
///         .where(
///           (note) => filter ? note.id.isEven : note.id.isOdd,
///         )
///         .toList();
///   }
///   return state.copyWith(visibleData: visibleData);
/// }
///```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MyFilterableBloc>().load();
/// ```
///
/// The `<T>` in the [NetworkFilterableState] represents datatype that [NetworkFilterableBloc] holds, and `<F>` represents the the filter data type, which can be any type, such as `bool`, `String`, a custom class, or an `enum`.
///
/// {@endtemplate}
abstract class NetworkFilterableBloc<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableBloc<T, S>
    with
        NetworkFilterableBaseMixin<T, F, S>,
        NetworkFilterableBlocMixin<T, F, S> {
  /// {@macro networkfilterablebloc}
  NetworkFilterableBloc(super.initialState) {
    super.network();
  }
}
