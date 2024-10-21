import 'package:stx_bloc_base/src/base/index.dart';
import 'package:stx_bloc_base/src/implementation/index.dart';
import 'package:bloc/bloc.dart';

/// {@template networklistbloc}
/// A utility class that extends [NetworkBloc] to simplify working with asynchronous `List` data. Like [NetworkListCubit], it shares the same methods as [addItem], [addItemAsync], [editItem], [editItemAsync], [removeItem], and [removeItemAsync], and also inheriting [load], [update], and [updateAsync] from [NetworkBloc].
///
/// The [onLoadAsync] and [equals] MUST be overridden when extending [NetworkListBloc].
///
/// ```dart
/// class Note {
///   const Note(this.id, this.item);

///   final int id;
///   final String item;
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
///   bool equals(Note note1, Note note2) {
///     return note1.id == note2.id;
///   }
/// }
/// ```
/// The key idea behind [NetworkListBloc] is to provide functionality similar to [Cubit], allowing specific events to be added by calling the provided methods: when [addItem], [addItemAsync], [editItem], [editItemAsync], [removeItem], and [removeItemAsync] are called, the corresponding [NetworkEventAddItem], [NetworkEventAddItemAsync], [NetworkEventEditItem], [NetworkEventAddItemAsync], [NetworkEventRemoveItem], or [NetworkEventRemoveItemAsync] are added internally to the [Bloc]).
///
/// This is achieved by invoking the [network] method from the [NetworkListBlocMixin] when [NetworkListBloc] is instantiated.
///
/// The [onLoadAsync] is invoked when [load] method is called from the UI.
/// ```dart
/// context.read<MyListBloc>().load();
/// ```
///
/// The [NetworkListState] is managed by [NetworkListBloc]. The `<T>` in [NetworkListState] represents the type of data that [NetworkListBloc] holds. Only the data type needs to be specified, not a `List<T>`.
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
