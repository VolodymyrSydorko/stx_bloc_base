import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    @Default(0) int noteId,
    @Default('') String message,
    DateTime? createdDate,
  }) = _Note;
}
