import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestSearchableNetworkBloc
    extends NetworkSearchableBloc<String, NetworkSearchableState<String>> {
  TestSearchableNetworkBloc()
      : super(NetworkSearchableState(data: '', visibleData: ''));

  @override
  Future<String> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return 'Loaded';
  }

  @override
  Future<String> onSearchAsync(String query) async {
    await Future.delayed(Duration(milliseconds: 100));

    return query;
  }

  NetworkSearchableState<String> onStateChanged(
      DataChangeReason reason, NetworkSearchableState<String> state) {
    if (reason.isSearched) {
      state = state.copyWith(data: state.query, visibleData: state.query);
    }

    return state.copyWith(status: NetworkStatus.success);
  }
}

void main() {
  group("TestSearchableNetworkBloc", () {
    blocTest(
      "Init state",
      build: () => TestSearchableNetworkBloc(),
      verify: (bloc) {
        expect(bloc.state.status.isInitial, isTrue);
        expect(bloc.state.data, isEmpty);
        expect(bloc.state.query, isNull);
      },
    );

    blocTest(
      "Load data",
      build: () => TestSearchableNetworkBloc(),
      act: (bloc) => bloc.load(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Loaded');
        expect(bloc.state.query, isNull);
      },
    );

    blocTest(
      "Search data",
      build: () => TestSearchableNetworkBloc(),
      act: (bloc) => bloc.search('Searched'),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched');
        expect(bloc.state.data, 'Searched');
        expect(bloc.state.visibleData, 'Searched');
      },
    );

    blocTest(
      "Search data async",
      build: () => TestSearchableNetworkBloc(),
      act: (bloc) => bloc.searchAsync('Searched async'),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched async');
        expect(bloc.state.data, 'Searched async');
        expect(bloc.state.visibleData, 'Searched async');
      },
    );

    blocTest(
      "Double search",
      build: () => TestSearchableNetworkBloc(),
      act: (bloc) {
        bloc.search('Searched');
        bloc.search('Searched2');
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.query, 'Searched2');
        expect(bloc.state.data, 'Searched2');
        expect(bloc.state.visibleData, 'Searched2');
      },
    );

    blocTest(
      "Load and search data (should return 'Loaded' because the load method takes longer)",
      build: () => TestSearchableNetworkBloc(),
      act: (bloc) {
        bloc
          ..load()
          ..search('Searched');
      },
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Loaded');
        expect(bloc.state.visibleData, 'Loaded');
        expect(bloc.state.query, 'Searched');
      },
    );
  });
}
