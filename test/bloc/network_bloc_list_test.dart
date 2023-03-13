import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';

class Person {
  final int id;
  final String firstName;
  final String lastName;

  Person(this.id, this.firstName, this.lastName);
}

final persons1 = [
  Person(1, 'FirstName1', 'LastName1'),
  Person(2, 'FirstName2', 'LastName2'),
  Person(3, 'FirstName3', 'LastName3'),
  Person(4, 'FirstName4', 'LastName4'),
];

class TestNetworkListBloc
    extends NetworkListBloc<Person, NetworkState<List<Person>>> {
  TestNetworkListBloc() : super(NetworkState(data: []));

  @override
  Future<List<Person>> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return persons1;
  }

  @override
  Future<List<Person>> onUpdateAsync(List<Person> updatedData) async {
    await Future.delayed(Duration(milliseconds: 100));

    return updatedData;
  }

  @override
  Future<Person> onAddItemAsync(Person newItem) async {
    await Future.delayed(Duration(milliseconds: 100));

    return newItem;
  }

  @override
  Future<Person> onEditItemAsync(Person updatedItem) async {
    await Future.delayed(Duration(milliseconds: 100));

    return updatedItem;
  }

  @override
  Future<bool> onRemoveItemAsync(Person removedItem) async {
    await Future.delayed(Duration(milliseconds: 100));

    return true;
  }

  @override
  bool equals(Person item1, Person item2) {
    return item1.id == item2.id;
  }
}

void main() {
  final newPerson1 = Person(10, 'New1', 'New1');
  final newPerson2 = Person(11, 'New2', 'New2');
  final editedPerson = Person(1, 'Updated', 'Updated');
  final removedPerson = Person(1, 'FirstName1', 'LastName1');

  group("TestNetworkListBloc", () {
    blocTest(
      "Init state",
      build: () => TestNetworkListBloc(),
      verify: (bloc) {
        expect(bloc.state.status.isInitial, isTrue);
        expect(bloc.state.data, isEmpty);
      },
    );

    blocTest(
      "Load state",
      build: () => TestNetworkListBloc(),
      act: (bloc) => bloc.load(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, persons1);
      },
    );
    blocTest(
      "Add item",
      build: () => TestNetworkListBloc(),
      act: (bloc) => bloc.addItem(newPerson1),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.length, 1);
      },
    );

    blocTest(
      "Add item async",
      build: () => TestNetworkListBloc(),
      act: (bloc) => bloc.addItemAsync(newPerson1),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.length, 1);
      },
    );

    blocTest(
      "Load and add items to the beginning and to the end",
      build: () => TestNetworkListBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        bloc.addItem(newPerson1, AddPosition.start);
        bloc.addItem(newPerson2);
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.length, persons1.length + 2);
        expect(bloc.state.data.first, newPerson1);
        expect(bloc.state.data.last, newPerson2);
      },
    );

    blocTest(
      "Edit item",
      build: () => TestNetworkListBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        bloc.editItem(editedPerson);
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.first, editedPerson);
      },
    );

    blocTest(
      "Edit item async",
      build: () => TestNetworkListBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        await bloc.editItemAsyncFuture(editedPerson);
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.first, editedPerson);
      },
    );

    blocTest(
      "Remove item",
      build: () => TestNetworkListBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        bloc.removeItem(removedPerson);
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.first, isNot(removedPerson));
      },
    );

    blocTest(
      "Remove item async",
      build: () => TestNetworkListBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        await bloc.removeItemAsyncFuture(removedPerson);
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data.first, isNot(removedPerson));
      },
    );
  });
}
