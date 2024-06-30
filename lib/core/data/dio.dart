import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:app/core/errors/failiure.dart';

import '../utils/results.dart';
import 'logger.dart';

const APPLICATION_JSON = 'application/json';
const CONTENT_TYPE = 'content-type';
const ACCEPT = 'accept';
const AUTHORIZATION = 'Authorization';
const DEFAULT_LANGUAGE = 'language';

// "";
final Map<String, String> mainheaders = {
  CONTENT_TYPE: APPLICATION_JSON,
  ACCEPT: '*/*',
  DEFAULT_LANGUAGE: 'en',
};

class ApiService {
  static String token = '';
  late Dio _dio;
  Dio get dio => _dio;

  static final ApiService _main = ApiService._internalUser();
  factory ApiService.main() {
    return _main;
  }
  ApiService._internalUser() {
    _dio = Dio(BaseOptions(
      baseUrl: "https://kjbn-truck-nest.onrender.com",
      sendTimeout: Duration(seconds: 300),
      connectTimeout: Duration(seconds: 300),
      receiveTimeout: Duration(seconds: 300),
    ))
      ..interceptors.addAll([LoggerInterceptor()]);
  }

  Future<Response> _get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(url,
        queryParameters: {...?queryParameters},
        options: Options(
          headers: {...mainheaders, AUTHORIZATION: "Bearer $token"},
        ));
  }

  Future<Response> _post(String url,
      {Object? data,
      Map<String, dynamic>? queryParams,
      ProgressCallback? onReceiveProgress}) async {
    return await dio.post(url,
        onReceiveProgress: onReceiveProgress,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: {...mainheaders, AUTHORIZATION: "Bearer $token"},
        ));
  }

  Future<Response> _patch(String url,
      {Object? data,
      Map<String, dynamic>? queryParams,
      ProgressCallback? onReceiveProgress}) async {
    return await dio.patch(url,
        onReceiveProgress: onReceiveProgress,
        data: data,
        queryParameters: queryParams,
        options: Options(
          headers: {...mainheaders, AUTHORIZATION: "Bearer $token"},
        ));
  }

  ResultFuture<T> post<T>(
    String url, {
    ProgressCallback? progressCallback,
    Object? data,
    Map<String, dynamic>? queryParams,
    required MapFunction<T> mapFunction,
  }) async {
    try {
      final response =
          await _post(url, data: data, onReceiveProgress: progressCallback);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // updateToken(response);
        final data = mapFunction(response.data);
        return Right(data);
      } else {
        return Left(ApiFailure(
            message: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 0));
      }
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.message ?? '', statusCode: e.response?.statusCode ?? 0));
    } catch (e) {
      return Left(ApiFailure(message: e.toString() ?? '', statusCode: 0));
    }
  }

  ResultFuture<T> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required MapFunction<T> mapFunction,
  }) async {
    try {
      final response = await _get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = mapFunction(response.data);
        return Right(data);
      } else {
        return Left(ApiFailure(
            message: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 0));
      }
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.message ?? '', statusCode: e.response?.statusCode ?? 0));
    } catch (e) {
      return Left(ApiFailure(message: e.toString() ?? '', statusCode: 0));
    }
  }

  ResultFuture<T> patch<T>(
    String url, {
    ProgressCallback? progressCallback,
    Object? data,
    Map<String, dynamic>? queryParams,
    required MapFunction<T> mapFunction,
  }) async {
    try {
      final response =
          await _patch(url, data: data, onReceiveProgress: progressCallback);
      if (response.statusCode == 200) {
        updateToken(response);
        final data = mapFunction(response.data);
        return Right(data);
      } else {
        return Left(ApiFailure(
            message: response.statusMessage ?? '',
            statusCode: response.statusCode ?? 0));
      }
    } on DioException catch (e) {
      return Left(ApiFailure(
          message: e.message ?? '', statusCode: e.response?.statusCode ?? 0));
    } catch (e) {
      return Left(ApiFailure(message: e.toString() ?? '', statusCode: 0));
    }
  }

  static updateToken(Response response) {
    if (response.data['token'] != null) {
      if (response.data['token'].toString().length > 10) {
        token = response.data['token'];
      }
    }
  }
}
