import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default(0) int age,
  }) = _Account;
}
