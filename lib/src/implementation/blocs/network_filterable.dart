import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networkfilterablebloc}
/// A utility class that extends [NetworkSearchableBloc] to facilitate working with asynchronous data. Like [NetworkFilterableCubit], it shares the same methods as [filter] and [filterAsync], and also inheriting [search], [searchAsync] from [NetworkSearchableBloc] and [load], [update], and [updateAsync] from [NetworkBloc].
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
/// The key idea behind [NetworkFilterableBloc] (and its descendants) is to provide functionality similar to `Cubit`, allowing specific events to be added by calling the provided methods: when [filter], [filterAsync], and inherited [search], [searchAsync], [load], [update], [updateAsync] are called, the corresponding [NetworkEventFilter], [NetworkEventFilterAsync], and inherited [NetworkEventSearch], [NetworkEventSearchAsync],[NetworkEventLoadAsync], [NetworkEventUpdate], or [NetworkEventUpdateAsync] are added internally to the `Bloc`).
///
/// This is achieved by invoking the [network] method from the [NetworkFilterableBlocMixin] when [NetworkFilterableBloc] is instantiated.
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
/// context.read<MyFilterableBloc>().load();
/// ```
///
/// The [NetworkFilterableState] is managed by the [NetworkFilterableBloc]. The `<T>` in the [NetworkFilterableState] represents datatype that [NetworkFilterableBloc] holds, and `<F>` represents the the filter data type, which can be any type, such as `bool`, `String`, a custom class, or an `enum`.
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
