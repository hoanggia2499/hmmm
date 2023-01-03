import 'dart:async';

import 'package:dartz/dartz.dart';

class FutureUtil {
  static Future<Tuple2<T1, T2>> waitConcurrentFuture2<T1, T2>(
      Future<T1> future1, Future<T2> future2) async {
    late T1 result1;
    late T2 result2;

    await Future.wait([
      future1.then((value) => result1 = value),
      future2.then((value) => result2 = value)
    ]);

    return Future.value(Tuple2(result1, result2));
  }

  static Future<Tuple3<T1, T2, T3>> waitConcurrentFuture3<T1, T2, T3>(
      Future<T1> future1, Future<T2> future2, Future<T3> future3) async {
    late T1 result1;
    late T2 result2;
    late T3 result3;

    await Future.wait([
      future1.then((value) => result1 = value),
      future2.then((value) => result2 = value),
      future3.then((value) => result3 = value)
    ]);

    return Future.value(Tuple3(result1, result2, result3));
  }

  static Future<Tuple4<T1, T2, T3, T4>> waitConcurrentFuture4<T1, T2, T3, T4>(
      Future<T1> future1,
      Future<T2> future2,
      Future<T3> future3,
      Future<T4> future4) async {
    late T1 result1;
    late T2 result2;
    late T3 result3;
    late T4 result4;

    await Future.wait([
      future1.then((value) => result1 = value),
      future2.then((value) => result2 = value),
      future3.then((value) => result3 = value),
      future4.then((value) => result4 = value)
    ]);

    return Future.value(Tuple4(result1, result2, result3, result4));
  }

  static Future<Tuple5<T1, T2, T3, T4, T5>>
      waitConcurrentFuture5<T1, T2, T3, T4, T5>(
          Future<T1> future1,
          Future<T2> future2,
          Future<T3> future3,
          Future<T4> future4,
          Future<T5> future5) async {
    late T1 result1;
    late T2 result2;
    late T3 result3;
    late T4 result4;
    late T5 result5;

    await Future.wait([
      future1.then((value) => result1 = value),
      future2.then((value) => result2 = value),
      future3.then((value) => result3 = value),
      future4.then((value) => result4 = value),
      future5.then((value) => result5 = value)
    ]);

    return Future.value(Tuple5(result1, result2, result3, result4, result5));
  }
}
