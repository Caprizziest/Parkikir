import '../model/register_model.dart';
import '../services/register_service.dart';

class RegisterRepository {
  final RegisterService service;

  RegisterRepository({required this.service});

  Future<Map<String, dynamic>> register(RegisterModel model) async {
    return await service.register(model);
  }
}
