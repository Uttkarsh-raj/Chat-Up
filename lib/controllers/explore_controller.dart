import 'package:chatit/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/apis/user_api.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(userApi: ref.watch(userApiProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

class ExploreController extends StateNotifier<bool> {
  final UserApi _userApi;
  ExploreController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userApi.searchUserByName(name);
    return users.map((e) {
      return UserModel.fromMap(e.data);
    }).toList();
  }
}
