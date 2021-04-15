extension DateTimeExt on DateTime {
  /// Returns the UTC DateTime in Singapore local time.
  ///
  /// If the DateTime is not in UTC, an AssertionError will be thrown.
  DateTime toSgt() {
    assert(this.isUtc);

    this.add(const Duration(hours: 8));

    // Return a new DateTime to get of the isUtc flag.
    return DateTime.fromMicrosecondsSinceEpoch(
      this.microsecondsSinceEpoch,
      isUtc: false,
    );
  }
}
