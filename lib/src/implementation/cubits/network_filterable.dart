import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkfilterablecubit}
/// A utility class that extends [NetworkSearchableCubit] to facilitate working with asynchronous data, providing convenience methods such as [filter] and [filterAsync], and also inheriting [search], [searchAsync] from [NetworkSearchableCubit] and [load], [update], and [updateAsync] from [NetworkCubit].
///
/// The [onLoadAsync] MUST be overridden when extending [NetworkFilterableCubit].
///
/// ```dart
///
/// class Note {
///   const Note(this.id, this.item);
///
///  final int id;
///  final String item;
/// }
/// typedef MyData = List<Note>;
///  // The bool represents the filter type, meaning that the boolean value should be passed to the filter() method.
/// typedef MyState = NetworkFilterableState<MyData, bool>;

/// class MyFilterableCubit extends NetworkFilterableCubit<MyData, bool, MyState> {
///   MyFilterableCubit()
///       : super(
///           const MyState(
///             data: [],
///             visibleData: [],
///           ),
///         );
///
///   @override
///   Future<MyData> onLoadAsync() async {
///    return someRepository.fetchData();
///   }
/// }
/// ```
///
/// Trigger [filter]/[filterAsync] from the UI example usage:
/// ```dart
/// TextButton(
///   onPressed: () => context.read<MyFilterableCubit>().filter(true),
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
///           (item) => filter ? item.id.isEven : item.id.isOdd,
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
///           (item) => item.item.contains(query),
///         )
///         .toList();
///   }
///
///   if (filter != null) {
///     visibleData = visibleData
///         .where(
///           (item) => filter ? item.id.isEven : item.id.isOdd,
///         )
///         .toList();
///   }
///   return state.copyWith(visibleData: visibleData);
/// }
///```
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MyFilterableCubit>().load();
/// ```
///
/// The [NetworkFilterableState] is managed by the [NetworkFilterableCubit]. The `<T>` in the [NetworkFilterableState] represents datatype that [NetworkFilterableCubit] holds, and `<F>` represents the the filter data type, which can be any type, such as `bool`, `String`, a custom class, or an `enum`.
///
/// {@endtemplate}
abstract class NetworkFilterableCubit<T, F,
        S extends NetworkFilterableState<T, F>>
    extends NetworkSearchableCubit<T, S>
    with NetworkFilterableBaseMixin<T, F, S> {
  /// {@macro networkfilterablecubit}
  NetworkFilterableCubit(super.initialState);
}
