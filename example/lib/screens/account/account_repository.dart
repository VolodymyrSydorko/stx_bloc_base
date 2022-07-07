import 'package:example/screens/account/models/models.dart';

class AccountRepository {
  Future<Account> getAccountInfo() async {
    await Future.delayed(const Duration(seconds: 1));

    return const Account(
      firstName: 'First name',
      lastName: 'Last name',
      age: 18,
    );
  }
}
