import 'package:chatit/controllers/user_profile_controller.dart';
import 'package:chatit/models/user_model.dart';
import 'package:chatit/screens/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/appwrite_constants.dart';

class UserProfileView extends ConsumerWidget {
  const UserProfileView(this.user, {super.key});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUser = user;
    return Scaffold(
      body: ref.watch(getlatestUserProfileDataProvider).when(
          data: (data) {
            if (data.events.contains(
                'databases.*.collections.${AppWriteConstants.userCollectionId}.documents.${copyOfUser.uid}.update')) {
              copyOfUser = UserModel.fromMap(data.payload);
            }
            return ProfilePage(copyOfUser);
          },
          error: (error, st) =>
              Scaffold(body: Center(child: Text(error.toString()))),
          loading: () {
            return ProfilePage(user);
          }),
    );
  }
}
