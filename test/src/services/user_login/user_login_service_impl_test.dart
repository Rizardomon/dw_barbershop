import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryMock extends Mock implements UserRepository {}

void main() {
  SharedPreferences.setMockInitialValues({});

  late UserRepository userRepository;
  late UserLoginService loginService;
  setUp(
    () {
      userRepository = UserRepositoryMock();
      loginService = UserLoginServiceImpl(userRepository: userRepository);
    },
  );
  test('Should return Success on login', () async {
    when(() => userRepository.login(any(), any()))
        .thenAnswer((_) async => Success('123'));

    final loginResult = await loginService.execute('email@teste.com', '123456');

    expect(loginResult, isA<Success>());
  });

  test('Should return AuthUnauthorizedException on invalid login', () async {
    when(() => userRepository.login(any(), any()))
        .thenAnswer((_) async => Failure(AuthUnauthorizedException()));

    final loginResult = await loginService.execute('email@teste.com', '123456');

    expect(loginResult, isA<Failure>());
  });

  test('Should return AuthError on exception', () async {
    when(() => userRepository.login(any(), any())).thenAnswer(
      (_) async => Failure(AuthError(message: 'Erro ao realizar login')),
    );

    final loginResult = await loginService.execute('email@teste.com', '123456');

    expect(loginResult, isA<Failure>());
  });
}
