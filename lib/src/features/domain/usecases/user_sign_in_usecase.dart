import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../core/params/sign_in_params.dart';
import '../../../core/usecase/usecase_interface.dart';
import '../repositories/auth_repository_interface.dart';

class UserSignInUsecase implements IUseCase<String, SignInParams> {
  final IAuthRepository authRepository;

  UserSignInUsecase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(SignInParams input) async {
    return await authRepository.signIn(input);
  }
}
