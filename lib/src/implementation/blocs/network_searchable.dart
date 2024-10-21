import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networksearchablebloc}
/// A utility class that simplifies working with asynchronous data, specifically for search and update operations. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// The [onLoadAsync] MUST be overridden when extending [NetworkSearchableBloc].
///
/// ```dart
/// typedef MyData = List<String>;
/// typedef MyState = NetworkSearchableState<MyData>;
///
/// class MyNetworkSearchableBloc extends NetworkSearchableBloc<MyData, MyState> {
///   MyNetworkSearchableBloc()
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
///
/// To trigger [search]/[searchAsync] from the UI when the text changes.
/// Example usage:
/// ```dart
/// TextField(
///   onChanged: context.read<MySearchableBloc>().search,
/// ),
/// ```
///
/// To perform [search] or [searchAsync] the [onStateChanged] needs to be overridden.
///```dart
///
///   @override
///   MyState onStateChanged(DataChangeReason reason, MyState state) {
///   final query = state.query;
///   var visibleData = state.data;
///
///   if (query != null && query.isNotEmpty) {
///     visibleData = visibleData
///         .where(
///           (item) => item.contains(query),
///         )
///         .toList();
///   }
///   return state.copyWith(visibleData: visibleData);
/// }
///```
///
/// Note: When working with `BlocBuilder`, the`state.visibleData` should be used.
///
///  For example:
///```dart
/// BlocBuilder<MyNetworkSearchableBloc, MyState>(
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
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// context.read<MyNetworkSearchableBloc>().load();
/// ```
/// The `<T>` in the [NetworkSearchableState] represents datatype that [NetworkSearchableBloc] holds.
///
/// {@endtemplate}
abstract class NetworkSearchableBloc<T, S extends NetworkSearchableState<T>>
    extends NetworkBloc<T, S>
    with NetworkSearchableBaseMixin<T, S>, NetworkSearchableBlocMixin<T, S> {
  /// {@macro networksearchablebloc}
  NetworkSearchableBloc(super.initialState) {
    super.network();
  }
}
