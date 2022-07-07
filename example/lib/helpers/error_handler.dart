import 'dart:io';

class ErrorHandler {
  static String parse(Object e, StackTrace stackTrace) {
    if (e is HttpException) {
      return e.message;
    }

    // if (e is NetworkDeleteException) {
    //   return 'NetworkDeleteException!';
    // }

    if (e is StateError) {
      return e.message;
    }

    return 'Something went wrong!';
  }
}
