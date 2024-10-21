import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networksearchablebloc}
/// A utility class that extends [NetworkBloc] to facilitate working with asynchronous data. Like [NetworkSearchableCubit], it shares the same methods as [search] and [searchAsync], and also inheriting [load], [update], and [updateAsync] from [NetworkBloc].
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
/// The key idea behind [NetworkSearchableBloc] is to provide functionality similar to `Cubit`, allowing specific events to be added by calling the provided methods: when [search], [searchAsync], and inherited [load], [update], [updateAsync] are called, the corresponding [NetworkEventSearch], [NetworkEventSearchAsync], and inherited [NetworkEventLoadAsync], [NetworkEventUpdate], or [NetworkEventUpdateAsync] are added internally to the `Bloc`).
///
/// This is achieved by invoking the [network] method from the [NetworkSearchableBlocMixin] when [NetworkSearchableBloc] is instantiated.
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
/// The [NetworkSearchableState] is managed by the [NetworkSearchableBloc]. The `<T>` in the [NetworkSearchableState] represents datatype that [NetworkSearchableBloc] holds.
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
