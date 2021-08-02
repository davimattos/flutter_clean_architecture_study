import 'package:flutter_clean_architecture/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams {
  final String? email;
  final String? password;

  AuthenticationParams({@required this.email, @required this.password});

  Map toJson() => {'email': email, 'password': password};
}
