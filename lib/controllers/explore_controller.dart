import 'package:chatit/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/user_api.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExploreController(userApi: ref.watch(userApiProvider));
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  return exploreController.searchUser(name);
});

final searchUserbyIdProvider =
    FutureProvider.family((ref, List<String> id) async {
  final exploreController = ref.watch(exploreControllerProvider.notifier);
  for (String i in id) {
    return exploreController.searchUserById(i);
  }
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

  Future<List<UserModel>> searchUserById(String id) async {
    final users = await _userApi.searchUserById(id);
    return users.map((e) {
      return UserModel.fromMap(e.data);
    }).toList();
  }
}
