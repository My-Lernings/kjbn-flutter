extension SwappableList<E> on List<E> {
  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}

extension LastIndex on List {
  int getLastIndex() => isEmpty ? 0 : length;
}
