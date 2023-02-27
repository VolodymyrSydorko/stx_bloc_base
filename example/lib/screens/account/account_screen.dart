import 'package:example/screens/account/account_bloc.dart';
import 'package:example/screens/account/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stx_bloc_base/stx_bloc_base.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(repository: AccountRepository())..load(),
      child: const AccountView(),
    );
  }
}

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Center(
        child: BlocConsumer<AccountBloc, TestState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMsg,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case NetworkStatus.success:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.data.firstName),
                    Text(state.data.lastName),
                    Text(state.data.age.toString()),
                    Text(state.counter.toString())
                  ],
                );
              case NetworkStatus.failure:
                return Text(state.errorMsg);
              default:
                return const Text('loading');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AccountBloc>().increaseCounter();
        },
      ),
    );
  }
}
