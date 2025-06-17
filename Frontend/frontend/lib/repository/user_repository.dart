import '../model/user_model.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(this._userService);

  Future<UserModel> getUserById(int userId) async {
    return await _userService.fetchUserById(userId);
  }
}
