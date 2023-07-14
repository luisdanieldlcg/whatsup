import 'package:fpdart/fpdart.dart';

extension OptionHelper<T> on Option<T> {
  /// Returns the option's value if it is `Some(value)`.
  /// Otherwise, throws an error.
  ///
  /// When you are sure that the option is `Some(value)`,
  /// you can call `unwrap()` to get the value.
  T unwrap() {
    return getOrElse(() => throw "called `Option.unwrap()` on a `None` value");
  }
}
