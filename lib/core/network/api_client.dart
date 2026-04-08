import 'dart:io';

import 'package:dio/dio.dart';

import '/core/constants/api_urls.dart';
import '/core/constants/app_constants.dart';
import '/core/error/exceptions.dart';
import '/core/utils/preferences_helper.dart';

/// Keep this true in the current setup:
/// use real endpoint paths while returning dummy responses.
const bool _useDummyResponses = true;

enum HttpMethod { get, post, put, delete, patch, download }

typedef ResponseConverter<T> = T Function(dynamic data);

class ApiClient {
  final Dio _dio;
  final PrefHelper _prefHelper;

  ApiClient({
    required Dio dio,
    required PrefHelper prefHelper,
  })  : _dio = dio,
        _prefHelper = prefHelper {
    _dio.options = BaseOptions(
      baseUrl: ApiUrl.base.url,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    );
  }

  Future<T> request<T>({
    required String endpoint,
    required HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? extraHeaders,
    String? savePath,
    ResponseConverter<T>? converter,
  }) async {
    if (_useDummyResponses) {
      final dummy = _dummyResponseFor(
        endpoint: endpoint,
        method: method,
        data: data,
        queryParameters: queryParameters,
        savePath: savePath,
      );

      if (converter != null) {
        return converter(dummy);
      }
      return dummy as T;
    }

    try {
      final options = Options(headers: _buildHeaders(extraHeaders));
      late final Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.post:
          response = await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case HttpMethod.download:
          if (savePath == null || savePath.isEmpty) {
            throw ServerException(message: 'savePath is required for download');
          }
          response = await _dio.download(
            endpoint,
            savePath,
            queryParameters: queryParameters,
            options: options,
          );
          break;
      }

      final body = response.data;
      if (converter != null) {
        return converter(body);
      }
      return body as T;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, String> _buildHeaders(Map<String, String>? extraHeaders) {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: AppConstants.applicationJson.key,
      ...?extraHeaders,
    };

    final token = _prefHelper.getString(AppConstants.token.key);
    if (token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] =
          '${AppConstants.bearer.key} $token';
    }

    return headers;
  }

  Exception _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Connection timeout');
      case DioExceptionType.connectionError:
        return NetworkException(message: 'Connection error');
      case DioExceptionType.cancel:
        return RequestCancelledException(message: 'Request cancelled');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        if (status == 400) {
          return BadRequestException(message: 'Bad request', statusCode: 400);
        }
        if (status == 401 || status == 403) {
          _prefHelper.setString(AppConstants.token.key, '');
          return UnauthorizedException(
            message: 'Unauthorized',
            statusCode: status,
          );
        }
        if (status == 404) {
          return NotFoundException(message: 'Not found', statusCode: 404);
        }
        if (status == 429) {
          return TooManyRequestsException(message: 'Too many requests');
        }
        return ServerException(
          message: 'Server error',
          statusCode: status,
        );
      default:
        return ServerException(message: e.message ?? 'Unknown server error');
    }
  }

  dynamic _dummyResponseFor({
    required String endpoint,
    required HttpMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? savePath,
  }) {
    if (endpoint == ApiUrl.home.url && method == HttpMethod.get) {
      return {
        'homes': [
          {'id': 1},
          {'id': 2},
          {'id': 3},
        ],
        'total': 3,
      };
    }

    if (method == HttpMethod.download) {
      return {
        'saved_to': savePath ?? '',
        'status': 'dummy_download_ok',
      };
    }

    return {
      'success': true,
      'endpoint': endpoint,
      'method': method.name,
      'query': queryParameters ?? <String, dynamic>{},
      'data': data,
      'message': 'Dummy response',
    };
  }
}
