import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_clean_template/core/network/api_client.dart';
import 'package:mvvm_clean_template/core/errors/exceptions.dart';

import 'api_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ApiClient apiClient;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    apiClient = ApiClient(client: mockHttpClient);
  });

  group('ApiClient', () {
    group('GET requests', () {
      test(
        'should return ApiResponse when GET request is successful',
        () async {
          // Arrange
          final responseData = {'id': 1, 'name': 'Test'};
          when(
            mockHttpClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer(
            (_) async => http.Response(json.encode(responseData), 200),
          );

          // Act
          final result = await apiClient.get('/test');

          // Assert
          expect(result.statusCode, 200);
          expect(result.data, responseData);
        },
      );

      test('should throw NotFoundException when status code is 404', () async {
        // Arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not found', 404));

        // Act & Assert
        expect(() => apiClient.get('/test'), throwsA(isA<NotFoundException>()));
      });

      test('should throw ServerException when status code is 500', () async {
        // Arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Server error', 500));

        // Act & Assert
        expect(() => apiClient.get('/test'), throwsA(isA<ServerException>()));
      });

      test(
        'should throw AuthenticationException when status code is 401',
        () async {
          // Arrange
          when(
            mockHttpClient.get(any, headers: anyNamed('headers')),
          ).thenAnswer((_) async => http.Response('Unauthorized', 401));

          // Act & Assert
          expect(
            () => apiClient.get('/test'),
            throwsA(isA<AuthenticationException>()),
          );
        },
      );
    });

    group('POST requests', () {
      test(
        'should return ApiResponse when POST request is successful',
        () async {
          // Arrange
          final requestData = {'name': 'Test'};
          final responseData = {'id': 1, 'name': 'Test'};
          when(
            mockHttpClient.post(
              any,
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => http.Response(json.encode(responseData), 201),
          );

          // Act
          final result = await apiClient.post('/test', data: requestData);

          // Assert
          expect(result.statusCode, 201);
          expect(result.data, responseData);
        },
      );

      test(
        'should throw ValidationException when status code is 400',
        () async {
          // Arrange
          when(
            mockHttpClient.post(
              any,
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer((_) async => http.Response('Bad request', 400));

          // Act & Assert
          expect(
            () => apiClient.post('/test', data: {'name': 'Test'}),
            throwsA(isA<ValidationException>()),
          );
        },
      );
    });

    group('PUT requests', () {
      test(
        'should return ApiResponse when PUT request is successful',
        () async {
          // Arrange
          final requestData = {'name': 'Updated'};
          final responseData = {'id': 1, 'name': 'Updated'};
          when(
            mockHttpClient.put(
              any,
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer(
            (_) async => http.Response(json.encode(responseData), 200),
          );

          // Act
          final result = await apiClient.put('/test/1', data: requestData);

          // Assert
          expect(result.statusCode, 200);
          expect(result.data, responseData);
        },
      );
    });

    group('DELETE requests', () {
      test(
        'should return ApiResponse when DELETE request is successful',
        () async {
          // Arrange
          when(
            mockHttpClient.delete(
              any,
              headers: anyNamed('headers'),
              body: anyNamed('body'),
            ),
          ).thenAnswer((_) async => http.Response('', 204));

          // Act
          final result = await apiClient.delete('/test/1');

          // Assert
          expect(result.statusCode, 204);
        },
      );
    });

    group('Headers', () {
      test('should include auth token in headers when set', () async {
        // Arrange
        apiClient.setAuthToken('test-token');
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('{}', 200));

        // Act
        await apiClient.get('/test');

        // Assert
        verify(
          mockHttpClient.get(
            any,
            headers: argThat(
              containsPair('Authorization', 'Bearer test-token'),
              named: 'headers',
            ),
          ),
        ).called(1);
      });

      test('should not include auth token after clearing', () async {
        // Arrange
        apiClient.setAuthToken('test-token');
        apiClient.clearAuthToken();
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('{}', 200));

        // Act
        await apiClient.get('/test');

        // Assert
        verify(
          mockHttpClient.get(
            any,
            headers: argThat(
              isNot(containsPair('Authorization', 'Bearer test-token')),
              named: 'headers',
            ),
          ),
        ).called(1);
      });
    });
  });
}
