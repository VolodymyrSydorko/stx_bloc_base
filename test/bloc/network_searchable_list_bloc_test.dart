import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestSearchableNetworkListBloc extends NetworkSearchableListBloc<String,
    NetworkSearchableListState<String>> {
  TestSearchableNetworkListBloc()
      : super(NetworkSearchableState(data: [], visibleData: []));

  @override
  Future<List<String>> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return ['Loaded'];
  }

  @override
  Future<List<String>> onSearchAsync(String query) async {
    await Future.delayed(Duration(milliseconds: 100));

    return [query];
  }

  @override
  bool equals(String item1, String item2) {
    throw UnimplementedError();
  }

  NetworkSearchableListState<String> onStateChanged(
      NetworkSearchableListState<String> state) {
    if (state.changeReason.isSearched) {
      state = state.copyWith(
          data: [state.query ?? ''], visibleData: [state.query ?? '']);
    }

    return state.copyWith(status: NetworkStatus.success);
  }
}

void main() {
  group("TestSearchableNetworkListBloc", () {
    blocTest(
      "Init state",
      build: () => TestSearchableNetworkListBloc(),
      verify: (bloc) {
        expect(bloc.state.status.isInitial, isTrue);
        expect(bloc.state.data, isEmpty);
        expect(bloc.state.query, isNull);
      },
    );

    blocTest(
      "Load data",
      build: () => TestSearchableNetworkListBloc(),
      act: (bloc) => bloc.load(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, ['Loaded']);
        expect(bloc.state.query, isNull);
      },
    );

    blocTest(
      "Search data",
      build: () => TestSearchableNetworkListBloc(),
      act: (bloc) => bloc.search('Searched'),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched');
        expect(bloc.state.data, ['Searched']);
        expect(bloc.state.visibleData, ['Searched']);
      },
    );

    blocTest(
      "Search data async",
      build: () => TestSearchableNetworkListBloc(),
      act: (bloc) => bloc.searchAsync('Searched async'),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched async');
        expect(bloc.state.data, ['Searched async']);
        expect(bloc.state.visibleData, ['Searched async']);
      },
    );

    blocTest(
      "Double search",
      build: () => TestSearchableNetworkListBloc(),
      act: (bloc) {
        bloc.search('Searched');
        bloc.search('Searched2');
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched2');
        expect(bloc.state.data, ['Searched2']);
        expect(bloc.state.visibleData, ['Searched2']);
      },
    );

    blocTest(
      "Load and search data (should return 'Loaded' because the load method takes longer)",
      build: () => TestSearchableNetworkListBloc(),
      act: (bloc) {
        bloc
          ..load()
          ..search('Searched');
      },
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, ['Loaded']);
        expect(bloc.state.visibleData, ['Loaded']);
        expect(bloc.state.query, 'Searched');
      },
    );
  });
}
