import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';
import 'package:tuple/tuple.dart';

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
    extends NetworkListBloc<Person, NetworkExtraListState<Person, int>>
    with
        NetworkExtraBaseMixin<List<Person>, int,
            NetworkExtraListState<Person, int>>,
        NetworkExtraBlocMixin<List<Person>, int,
            NetworkExtraListState<Person, int>> {
  TestNetworkListBloc() : super(NetworkExtraState(data: [], extraData: 0)) {
    super.network();
  }

  @override
  Future<List<Person>> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return persons1;
  }

  @override
  Future<Tuple2<List<Person>, int>> onLoadWithExtraAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return Tuple2(persons1, 1);
  }

  @override
  Future<int> onLoadExtraAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return 1;
  }

  @override
  bool equals(Person item1, Person item2) {
    return item1.id == item2.id;
  }
}

void main() {
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
        expect(bloc.state.extraData, 0);
        expect(bloc.state.data, persons1);
      },
    );

    blocTest(
      "Load extra state",
      build: () => TestNetworkListBloc(),
      act: (bloc) => bloc.loadExtra(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.extraData, 1);
        expect(bloc.state.data, []);
      },
    );

    blocTest(
      "Load with extra state",
      build: () => TestNetworkListBloc(),
      act: (bloc) => bloc.loadWithExtra(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.extraData, 1);
        expect(bloc.state.data, persons1);
      },
    );
  });
}
