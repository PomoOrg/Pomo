import '../../../core/params/sign_in_params.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/http_client/http_client_interface.dart';
import '../../../core/http_client/http_response.dart';
import '../../../core/params/sign_up_params.dart';
import '../../../utils/api_endpoints.dart';
import '../models/user_model.dart';

abstract class IAuthDatasource {
  Future<String> signIn(SignInParams credentials);
  Future<UserModel> signUp(SignUpParams credentials);
}

class AuthDatasourceImpl implements IAuthDatasource {
  final IHttpClient httpClient;

  AuthDatasourceImpl(this.httpClient);

  @override
  Future<String> signIn(SignInParams credentials) async {
    HttpResponse response = await httpClient.post(
      SIGN_IN_ENDPOINT,
      body: {
        "email": credentials.email,
        "password": credentials.password,
      },
      headers: {"Content-Type": "application/json"},
    );

    switch (response.statusCode) {
      case 200:
        return response.body["token"];
      case 400:
        throw InvalidCredentialsException();
      case 500:
        throw ServerException();
      default:
        throw SignInException();
    }
  }

  @override
  Future<UserModel> signUp(SignUpParams credentials) async {
    HttpResponse response = await httpClient.post(
      SIGN_UP_ENDPOINT,
      body: {
        "name": credentials.name,
        "username": credentials.username,
        "email": credentials.email,
        "password": credentials.password,
      },
      headers: {"Content-Type": "application/json"},
    );

    switch (response.statusCode) {
      case 201:
        return UserModel.fromJson(response.body["user"]);
      case 400:
        throw CredentialsAlreadyInUseException();
      case 500:
        throw ServerException();
      default:
        throw SignUpException();
    }
  }
}
