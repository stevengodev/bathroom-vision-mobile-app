import 'package:bathroom_vision/features/auth/data/user_api.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';

class UserRepository {

  final UserApi userApi;

  UserRepository(this.userApi);

  Future<UserResponse> getProfile() async {
    return await userApi.getProfile();
  }

}