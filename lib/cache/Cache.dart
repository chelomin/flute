import 'dart:async';

abstract class Cache<T> {
  Future<T> get(int index);
  put(int index, T object);
}