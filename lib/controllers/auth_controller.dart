import 'package:appwrite/models.dart' as model;
import 'package:chatit/models/apis/auth_api.dart';
import 'package:chatit/models/apis/user_api.dart';
import 'package:chatit/models/user_model.dart';
import 'package:chatit/view/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../core/utils.dart';
import '../view/screens/login_page.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authApi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserProvider).value!.$id;
  print("uid: " + currentUserId);
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  print('name: ' + '${userDetails.value?.name.toString()}');
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  print("authcontroller: " + authController.getUserData(uid).toString());
  return authController.getUserData(uid);
});

final currentUserProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userAPi;
  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userAPi = userApi,
        super(false);

  Future<model.Account?> currentUser() => _authApi.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.signup(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackbar(context, l),
      (r) async {
        UserModel userModel = UserModel(
          name: getNameFromEmail(email),
          email: email,
          contacts: const [],
          bannerPic: "",
          uid: r.$id,
          bio: '',
          profilePic: '',
        );
        final result = await _userAPi.saveUserData(userModel);
        result.fold(
          (l) => showSnackbar(context, l.toString()),
          (r) {
            showSnackbar(context, 'Account Created! Please Login.');
            Navigator.push(
              context,
              PageTransition(
                child: const LoginPage(),
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 100),
                alignment: Alignment.center,
              ),
            );
          },
        );
      },
    );
  }

  void logIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authApi.login(email: email, password: password);
    state = false;
    res.fold(
      (l) => showSnackbar(context, l),
      (r) {
        Navigator.push(
          context,
          PageTransition(
            child: const HomePage(),
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 100),
            alignment: Alignment.center,
          ),
        );
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPi.getUserData(uid);
    print(document);
    final updatedUser = UserModel.fromMap(document.data);
    // print('docs' + document.data);
    // print("updated user:" + updatedUser.uid);
    return updatedUser;
  }
}

// final authControllerProvider =
//     StateNotifierProvider<AuthController, bool>((ref) {
//   return AuthController(
//     authAPI: ref.watch(authApiProvider),
//     userAPI: ref.watch(userApiProvider),
//   );
// });

// final currentUserDetailsProvider = FutureProvider((ref) {
//   final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
//   final userDetails = ref.watch(userDetailsProvider(currentUserId));
//   return userDetails.value;
// });

// final userDetailsProvider = FutureProvider.family((ref, String uid) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.getUserData(uid);
// });

// final currentUserAccountProvider = FutureProvider((ref) {
//   final authController = ref.watch(authControllerProvider.notifier);
//   return authController.currentUser();
// });

// class AuthController extends StateNotifier<bool> {
//   final AuthApi _authAPI;
//   final UserApi _userAPI;
//   AuthController({
//     required AuthApi authAPI,
//     required UserApi userAPI,
//   })  : _authAPI = authAPI,
//         _userAPI = userAPI,
//         super(false);
//   // state = isLoading

//   Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

//   void signUp({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final res = await _authAPI.signup(
//       email: email,
//       password: password,
//     );
//     state = false;
//     res.fold(
//       (l) => showSnackbar(context, l.toString()),
//       (r) async {
//         UserModel userModel = UserModel(
//           name: getNameFromEmail(email),
//           email: email,
//           contacts: const [],
//           bannerPic: "",
//           uid: r.$id,
//           bio: '',
//           profilePic: '',
//         );
//         final res2 = await _userAPI.saveUserData(userModel);
//         res2.fold((l) => showSnackbar(context, l.toString()), (r) {
//           showSnackbar(context, 'Accounted created! Please login.');
//           Navigator.push(
//             context,
//             PageTransition(
//               child: const LoginPage(),
//               type: PageTransitionType.fade,
//               duration: const Duration(milliseconds: 100),
//               alignment: Alignment.center,
//             ),
//           );
//         });
//       },
//     );
//   }

//   void login({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final res = await _authAPI.login(
//       email: email,
//       password: password,
//     );
//     state = false;
//     res.fold(
//       (l) => showSnackbar(context, l.toString()),
//       (r) {
//         Navigator.push(
//           context,
//           PageTransition(
//             child: const HomePage(),
//             type: PageTransitionType.fade,
//             duration: const Duration(milliseconds: 100),
//             alignment: Alignment.center,
//           ),
//         );
//       },
//     );
//   }

//   Future<UserModel> getUserData(String uid) async {
//     final document = await _userAPI.getUserData(uid);
//     final updatedUser = UserModel.fromMap(document.data);
//     return updatedUser;
//   }
// }
