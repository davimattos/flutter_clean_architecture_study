import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:flutter_clean_architecture/domain/usecases/usecases.dart';
import 'package:flutter_clean_architecture/domain/helpers/helpers.dart';

import 'package:flutter_clean_architecture/data/http/http.dart';
import 'package:flutter_clean_architecture/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(httpClient.request(
        url: url,
        method: 'post',
        body: {'email': params.email, 'password': params.password}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400 ', () async {
    when(httpClient.request(
            url: url,
            method: 'post',
            body: {'email': params.email, 'password': params.password}))
        .thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}