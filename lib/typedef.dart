import 'package:fpdart/fpdart.dart';
import 'package:slice_quest/error_handle.dart';

typedef EitherUser<T> = Future<Either<ErrorHandle, T>>;
typedef EitherReview<T> = Future<Either<ErrorHandle, T>>;
