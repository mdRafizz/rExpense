/// Minimal Either monad for functional error handling.
/// Left = failure, Right = success.
sealed class Either<L, R> {
  const Either();

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  L get left => (this as Left<L, R>).value;
  R get right => (this as Right<L, R>).value;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    return switch (this) {
      Left<L, R>(value: final v) => onLeft(v),
      Right<L, R>(value: final v) => onRight(v),
    };
  }

  Either<L, T> map<T>(T Function(R) f) {
    return switch (this) {
      Left<L, R>(value: final v) => Left(v),
      Right<L, R>(value: final v) => Right(f(v)),
    };
  }

  Either<L, T> flatMap<T>(Either<L, T> Function(R) f) {
    return switch (this) {
      Left<L, R>(value: final v) => Left(v),
      Right<L, R>(value: final v) => f(v),
    };
  }
}

final class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
}

final class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
}

Either<L, R> left<L, R>(L value) => Left(value);
Either<L, R> right<L, R>(R value) => Right(value);
