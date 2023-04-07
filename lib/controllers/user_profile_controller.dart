import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils.dart';
import '../models/apis/user_api.dart';
import '../models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userApi: ref.watch(userApiProvider),
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserApi _userApi;
  UserProfileController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  void addToMessages({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    if (!currentUser.contacts.contains(user.uid)) {
      user.contacts.add(currentUser.uid);
      currentUser.contacts.add(user.uid);
    }
    final res = await _userApi.addToContacts(currentUser);
    res.fold(
      (l) => showSnackbar(context, l.toString()),
      (r) async {
        final res2 = await _userApi.addToContacts(user);
        res2.fold(
          (l) => showSnackbar(context, l.toString()),
          (r) => null,
        );
      },
    );
  }
}
