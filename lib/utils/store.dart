/*
 This Store class is meant for transient storage of data
 */

class Store {
  Store._p();

  static final Store _instance = Store._p();
  factory Store() => _instance;

  final Map<String, dynamic> _store = {};

  put(String key, dynamic value) {
    _store[key] = value;
  }

  dynamic get(String key) {
    return _store[key];
  }
}
