import 'package:stx_bloc_base/src/base/mixins/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';

/// {@template networksearchablecubit}
/// A utility class that extends [NetworkCubit] to facilitate working with asynchronous data, providing convenience methods such as [search] and [searchAsync], and also inheriting [load], [update], and [updateAsync] from [NetworkCubit].
///
/// The [onLoadAsync] MUST be overridden when extending [NetworkSearchableCubit].
///
/// ```dart
/// typedef MyData = List<String>;
/// typedef MyState = NetworkSearchableState<MyData>;
///
/// class MyNetworkSearchableCubit extends NetworkSearchableCubit<MyData, MyState> {
///   MyNetworkSearchableCubit()
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
///   onChanged: context.read<MySearchableCubit>().search,
/// ),
/// ```
/// To perform [search] or [searchAsync] the [onStateChanged] needs to be overridden.
///```dart
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
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
///
/// ```dart
/// context.read<MyNetworkSearchableCubit>().load();
/// ```
///
/// The [NetworkSearchableState] is managed by the [NetworkSearchableCubit]. The `<T>` in the [NetworkSearchableState] represents datatype that [NetworkSearchableCubit] holds.
///
/// {@endtemplate}
abstract class NetworkSearchableCubit<T, S extends NetworkSearchableState<T>>
    extends NetworkCubit<T, S> with NetworkSearchableBaseMixin<T, S> {
  /// {@macro networksearchablecubit}
  NetworkSearchableCubit(super.initialState);
}
