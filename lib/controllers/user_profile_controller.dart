import 'dart:io';

import 'package:chatit/apis/storage_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils.dart';
import '../apis/user_api.dart';
import '../models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userApi: ref.watch(userApiProvider),
    storageApi: ref.watch(storageAPIProvider),
  );
});

final getlatestUserProfileDataProvider = StreamProvider((ref) {
  final userApi = ref.watch(userApiProvider);
  return userApi.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final UserApi _userApi;
  final StorageAPI _storageApi;
  UserProfileController({
    required UserApi userApi,
    required StorageAPI storageApi,
  })  : _userApi = userApi,
        _storageApi = storageApi,
        super(false);

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final banerUrl = await _storageApi.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: banerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageApi.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }
    final res = await _userApi.updateUserData(userModel);
    state = false;
    res.fold((l) => showSnackbar(context, l.toString()),
        (r) => Navigator.of(context).pop());
  }

  void addToMessages({
    required UserModel user,
    required BuildContext context,
    required UserModel? currentUser,
  }) async {
    if (currentUser != null) {
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
}
