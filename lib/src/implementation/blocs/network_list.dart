import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';
import 'package:bloc/bloc.dart';

/// {@template networklistbloc}
/// A utility class that simplifies working with asynchronous `List` data. Instead of manually adding the event, simply call the desired method, which internally adds the corresponding event to the [Bloc] and ensures it is handled by internally.
///
/// The [onLoadAsync] and [equals] MUST be overridden when extending [NetworkListBloc].
///
/// ```dart
/// class Note {
///   const Note(this.id, this.message);

///   final int id;
///   final String message;
/// }
/// /// In the state specify <Note> instead of List<Note>.
/// typedef MyListState = NetworkListState<Note>;

/// class MyListBloc extends NetworkListBloc<Note, MyListState> {
///   MyListBloc() : super(const NetworkListState(data: []));
///
///   @override
///   Future<List<Note>> onLoadAsync() async {
///    return someRepository.fetchData();
///   }
///
///   @override
///   bool equals(Note item1, Note item2) {
///     return item1.id == item.id;
///   }
/// }
/// ```
///
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// context.read<MyListBloc>().load();
/// ```
///
/// The `<T>` in [NetworkListState] represents the type of data that [NetworkListBloc] holds. Only the data type needs to be specified, not a `List<T>`.
///
/// {@endtemplate}
abstract class NetworkListBloc<T, S extends NetworkListState<T>>
    extends NetworkBloc<List<T>, S>
    with NetworkListBaseMixin<T, S>, NetworkListBlocMixin<T, S> {
  /// {@macro networklistbloc}
  NetworkListBloc(super.initialState) {
    super.network();
  }
}
