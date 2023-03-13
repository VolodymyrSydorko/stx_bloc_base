import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestFilterableNetworkListCubit extends NetworkFilterableListCubit<String,
    String, NetworkFilterableListState<String, String>> {
  TestFilterableNetworkListCubit()
      : super(NetworkFilterableState(data: [], visibleData: []));

  @override
  Future<List<String>> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return ['Loaded'];
  }

  @override
  Future<List<String>> onFilterAsync(String filter) async {
    await Future.delayed(Duration(milliseconds: 100));

    return [filter];
  }

  @override
  bool equals(String item1, String item2) {
    throw UnimplementedError();
  }

  NetworkFilterableListState<String, String> onStateChanged(
      DataChangeReason reason,
      NetworkFilterableListState<String, String> state) {
    if (reason.isFiltered) {
      state = state.copyWith(
          data: [state.filter ?? ''], visibleData: [state.filter ?? '']);
    }

    return state.copyWith(status: NetworkStatus.success);
  }
}

void main() {
  group("TestFilterableNetworkListCubit", () {
    blocTest(
      "Init state",
      build: () => TestFilterableNetworkListCubit(),
      verify: (bloc) {
        expect(bloc.state.status.isInitial, isTrue);
        expect(bloc.state.data, isEmpty);
        expect(bloc.state.filter, isNull);
      },
    );

    blocTest(
      "Load data",
      build: () => TestFilterableNetworkListCubit(),
      act: (bloc) => bloc.load(),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, ['Loaded']);
        expect(bloc.state.filter, isNull);
      },
    );

    blocTest(
      "Filter data",
      build: () => TestFilterableNetworkListCubit(),
      act: (bloc) => bloc.filter('Filtered'),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.filter, 'Filtered');
        expect(bloc.state.data, ['Filtered']);
        expect(bloc.state.visibleData, ['Filtered']);
      },
    );

    blocTest(
      "Filter data async",
      build: () => TestFilterableNetworkListCubit(),
      act: (bloc) => bloc.filterAsync('Filtered async'),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.filter, 'Filtered async');
        expect(bloc.state.data, ['Filtered async']);
        expect(bloc.state.visibleData, ['Filtered async']);
      },
    );

    blocTest(
      "Double filter",
      build: () => TestFilterableNetworkListCubit(),
      act: (bloc) {
        bloc.filter('Filtered');
        bloc.filter('Filtered2');
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.filter, 'Filtered2');
        expect(bloc.state.data, ['Filtered2']);
        expect(bloc.state.visibleData, ['Filtered2']);
      },
    );

    blocTest(
      "Load and filter data (should return 'Loaded' because the load method takes longer)",
      build: () => TestFilterableNetworkListCubit(),
      act: (bloc) {
        bloc
          ..load()
          ..filter('Filtered');
      },
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, ['Loaded']);
        expect(bloc.state.visibleData, ['Loaded']);
        expect(bloc.state.filter, 'Filtered');
      },
    );
  });
}
