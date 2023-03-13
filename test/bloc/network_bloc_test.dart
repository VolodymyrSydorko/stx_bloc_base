import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'package:stx_bloc_base/stx_bloc_base.dart';

class TestNetworkBloc extends NetworkBloc<String, NetworkState<String>> {
  int loadCount = 0;

  TestNetworkBloc() : super(NetworkState(data: ''));

  @override
  Future<String> onLoadAsync() async {
    await Future.delayed(Duration(milliseconds: 100));

    return ++loadCount == 1 ? 'Loaded' : 'Reloaded';
  }

  @override
  Future<String> onUpdateAsync(String updatedData) async {
    await Future.delayed(Duration(milliseconds: 100));

    return updatedData;
  }
}

void main() {
  group("TestNetworkBloc", () {
    blocTest(
      "Init state",
      build: () => TestNetworkBloc(),
      verify: (bloc) {
        expect(bloc.state.status.isInitial, isTrue);
        expect(bloc.state.data, isEmpty);
      },
    );

    blocTest(
      "Load data",
      build: () => TestNetworkBloc(),
      act: (bloc) => bloc.load(),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Loaded');
      },
    );

    blocTest(
      "Reload data",
      build: () => TestNetworkBloc(),
      act: (bloc) {
        bloc.load();
        bloc.load();
      },
      wait: Duration(milliseconds: 200),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Reloaded');
      },
    );

    blocTest(
      "Update data",
      build: () => TestNetworkBloc(),
      act: (bloc) => bloc.update('Updated'),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Updated');
      },
    );

    blocTest(
      "Update data async",
      build: () => TestNetworkBloc(),
      act: (bloc) => bloc.updateAsync('Updated async'),
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Updated async');
      },
    );

    blocTest(
      "Load and update data (should return 'Loaded' because the load method takes longer)",
      build: () => TestNetworkBloc(),
      act: (bloc) {
        bloc
          ..load()
          ..update('Updated');
      },
      wait: Duration(milliseconds: 100),
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Loaded');
      },
    );

    blocTest(
      "Init load data future (should load only once)",
      build: () => TestNetworkBloc(),
      act: (bloc) async {
        await bloc.initLoadAsyncFuture();
        await bloc.initLoadAsyncFuture();
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Loaded');
      },
    );

    blocTest(
      "Reload data future",
      build: () => TestNetworkBloc(),
      act: (bloc) async {
        await bloc.loadAsyncFuture();
        await bloc.loadAsyncFuture();
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Reloaded');
      },
    );

    blocTest(
      "Update data async future",
      build: () => TestNetworkBloc(),
      act: (bloc) async {
        await bloc.updateAsyncFuture('Updated');
        await bloc.updateAsyncFuture('Updated2');
      },
      verify: (bloc) {
        expect(bloc.state.status.isSuccess, isTrue);
        expect(bloc.state.data, 'Updated2');
      },
    );
  });
}
