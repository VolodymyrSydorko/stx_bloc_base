extension ListExtension<T> on List<T> {
  List<T> replaceWhere(
      bool Function(T) predicate, T Function(T oldValue) toReplace,
      [bool deepCopy = true]) {
    final index = indexWhere(predicate);
    return ((deepCopy ? toList() : this)..[index] = toReplace(this[index]));
  }

  List<T> whereList(bool Function(T) test) => where(test).toList();
}
