import 'package:dartz/dartz.dart';
import 'package:app/core/errors/failiure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef VoidFuture = Future<Either<Failure, void>>;

typedef MapFunction<T> = T Function(dynamic input);
