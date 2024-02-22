extension DynamicCasting on Object? {
  T? as<T>() => this is T ? this as T : null;
}
