/// Mixin for providing total invested minutes calculation for a task-like entity.
mixin TaskTimeMixin<T> {
  /// Returns the total invested time in minutes for the entity.
  int get totalInvestedMinutes;
}
