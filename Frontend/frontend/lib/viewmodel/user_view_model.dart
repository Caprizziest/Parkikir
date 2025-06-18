import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';
import '../services/token_storage.dart';
import '../services/user_service.dart';

// State for UserViewModel
class UserState {
  final UserModel? user;
  final String errorMessage;
  final bool isLoading;

  UserState({this.user, this.errorMessage = '', this.isLoading = false});

  UserState copyWith({
    UserModel? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return UserState( 
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// UserViewModel
class UserViewModel extends StateNotifier<UserState> {
  final UserRepository _userRepository;
  final TokenStorage _tokenStorage;

  UserViewModel(this._userRepository, this._tokenStorage) : super(UserState());

  Future<void> fetchAndSetUsername() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null) {
        state = state.copyWith(
            errorMessage: 'No access token found.', isLoading: false);
        return;
      }

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      final userId =
          payload['user_id']; // Assuming your JWT payload contains 'user_id'

      if (userId == null) {
        state = state.copyWith(
            errorMessage: 'User ID not found in token.', isLoading: false);
        return;
      }

      final user = await _userRepository.getUserById(userId);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}

// Providers
final tokenStorageProvider = Provider((ref) => TokenStorage());
final userServiceProvider =
    Provider((ref) => UserService(ref.read(tokenStorageProvider)));
final userRepositoryProvider =
    Provider((ref) => UserRepository(ref.read(userServiceProvider)));
final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>(
  (ref) => UserViewModel(
      ref.read(userRepositoryProvider), ref.read(tokenStorageProvider)),
);
