import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:speckit_flutter_template/core/constants/app_constants.dart';
import 'package:speckit_flutter_template/core/errors/exceptions.dart';

/// Response wrapper class to provide similar interface as before
class ApiResponse {

  ApiResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
  });
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;
}

class ApiClient {

  ApiClient({http.Client? client})
    : _client = client ?? http.Client(),
      _baseUrl = '${AppConstants.baseUrl}/${AppConstants.apiVersion}',
      _timeout = const Duration(milliseconds: AppConstants.connectionTimeout),
      _defaultHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;
  final Map<String, String> _defaultHeaders;

  /// Set authorization token
  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization token
  void clearAuthToken() {
    _defaultHeaders.remove('Authorization');
  }

  /// Update default headers
  void updateHeaders(Map<String, String> headers) {
    _defaultHeaders.addAll(headers);
  }

  /// Build full URL with query parameters
  Uri _buildUri(String path, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse('$_baseUrl$path');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  /// Merge headers
  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) => {..._defaultHeaders, ...?additionalHeaders};

  /// Parse response body
  dynamic _parseResponseBody(http.Response response) {
    if (response.body.isEmpty) {
      return null;
    }
    try {
      return json.decode(response.body);
    } catch (_) {
      return response.body;
    }
  }

  /// Handle response and check for errors
  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        statusCode: response.statusCode,
        data: _parseResponseBody(response),
        headers: response.headers,
      );
    }
    throw _handleStatusCode(response.statusCode);
  }

  /// GET request
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client
          .get(uri, headers: _mergeHeaders(headers))
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on Exception catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException ||
          e is AuthenticationException ||
          e is AuthorizationException ||
          e is NotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final body = data != null ? json.encode(data) : null;
      final response = await _client
          .post(uri, headers: _mergeHeaders(headers), body: body)
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on Exception catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException ||
          e is AuthenticationException ||
          e is AuthorizationException ||
          e is NotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// PUT request
  Future<ApiResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final body = data != null ? json.encode(data) : null;
      final response = await _client
          .put(uri, headers: _mergeHeaders(headers), body: body)
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on Exception catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException ||
          e is AuthenticationException ||
          e is AuthorizationException ||
          e is NotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// PATCH request
  Future<ApiResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final body = data != null ? json.encode(data) : null;
      final response = await _client
          .patch(uri, headers: _mergeHeaders(headers), body: body)
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on Exception catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException ||
          e is AuthenticationException ||
          e is AuthorizationException ||
          e is NotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// DELETE request
  Future<ApiResponse> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final response = await _client
          .delete(
            uri,
            headers: _mergeHeaders(headers),
            body: data != null ? json.encode(data) : null,
          )
          .timeout(_timeout);
      return _handleResponse(response);
    } on TimeoutException {
      throw NetworkException('Connection timeout');
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } on Exception catch (e) {
      if (e is ServerException ||
          e is NetworkException ||
          e is ValidationException ||
          e is AuthenticationException ||
          e is AuthorizationException ||
          e is NotFoundException) {
        rethrow;
      }
      throw NetworkException();
    }
  }

  /// Handle HTTP status codes
  Exception _handleStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ValidationException('Bad request');
      case 401:
        return AuthenticationException('Unauthorized');
      case 403:
        return AuthorizationException('Forbidden');
      case 404:
        return NotFoundException();
      case 500:
      case 502:
      case 503:
        return ServerException('Server error');
      default:
        return ServerException('Server error with status code: $statusCode');
    }
  }

  /// Close the client when done
  void dispose() {
    _client.close();
  }
}
