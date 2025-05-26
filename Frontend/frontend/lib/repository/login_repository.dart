
import '../model/login_model.dart';
import '../services/login_service.dart';

class LoginRepository {
  final LoginService service;

  LoginRepository({required this.service});

  Future<Map<String, dynamic>> login(LoginModel model) async {
    return await service.login(model);
  }
}
