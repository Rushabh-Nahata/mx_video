import '../../core/error/failure.dart';

/// A discriminated union for use-case return values.
/// Prefer returning [Result<T>] from repositories instead of throwing.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

extension ResultX<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Err<T>;

  T get value => (this as Success<T>).value;
  Failure get failure => (this as Err<T>).failure;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
  }) =>
      switch (this) {
        Success<T> s => onSuccess(s.value),
        Err<T> e => onError(e.failure),
      };
}
