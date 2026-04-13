import 'package:bathroom_vision/features/auth/data/user_api.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/shared/enums/role.dart';

class UserRepository {

  final UserApi userApi;

  UserRepository(this.userApi);

  Future<UserResponse> getProfile() async {
    return await userApi.getProfile();
  }

  Future<List<UserResponse>> getUsersByRole(Role role) async {
    return await userApi.getByRole(role);
  }

}