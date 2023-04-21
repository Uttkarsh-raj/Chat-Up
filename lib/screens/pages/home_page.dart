import 'package:chatit/controllers/auth_controller.dart';
import 'package:chatit/controllers/explore_controller.dart';
import 'package:chatit/controllers/user_profile_controller.dart';
import 'package:chatit/models/user_model.dart';
import 'package:chatit/screens/widgets/custom_textfield.dart';
import 'package:chatit/screens/widgets/search_tile.dart';
import 'package:chatit/view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../constants/appwrite_constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  PopupMenuItem _buildPopupMenuItem(String title, IconData icon) {
    return PopupMenuItem(
      child: Row(
        children: [
          Icon(
            icon,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late UserModel copyofUser;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      body: (currentUser == null)
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: UserProfileView(currentUser),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(currentUser.profilePic),
                                  radius: 30,
                                ),
                                if (currentUser.bannerPic == '' ||
                                    currentUser.profilePic == '' ||
                                    currentUser.bio == '')
                                  const CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 5,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const Text(
                            'Chat-Up',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showLogoutAlertDialog(context),
                            child: const Icon(
                              Icons.logout_outlined,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      onSubmmit: (value) {
                        setState(() {
                          isShowUsers = true;
                        });
                      },
                      label: 'Search',
                      icon: Icons.search_outlined,
                      obscure: false,
                      controller: searchController,
                    ),
                    const SizedBox(height: 10),
                    (searchController.text.isNotEmpty)
                        ? ref
                            .watch(searchUserProvider(searchController.text))
                            .when(
                              data: (users) {
                                return Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return SearchTile(receiver: user);
                                    },
                                  ),
                                );
                              },
                              error: (error, st) {
                                return Text(error.toString());
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                        : ref.watch(getlatestUserProfileDataProvider).when(
                            data: (data) {
                              if (data.events.contains(
                                  'databases.*.collections.${AppWriteConstants.userCollectionId}.documents.${currentUser.uid}.update')) {
                                copyofUser = UserModel.fromMap(data.payload);
                              }
                              return Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: copyofUser.contacts.length,
                                      itemBuilder: (context, index) {
                                        final user = ref
                                            .watch(userDetailsProvider(
                                                currentUser.contacts[index]))
                                            .value;
                                        if (user != null) {
                                          return SearchTile(receiver: user);
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            error: (error, st) => Scaffold(
                                body: Center(child: Text(error.toString()))),
                            loading: () => (currentUser.contacts.isNotEmpty)
                                ? Expanded(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: currentUser.contacts.length,
                                      itemBuilder: (context, index) {
                                        final user = ref
                                            .watch(userDetailsProvider(
                                                currentUser.contacts[index]))
                                            .value;
                                        if (user != null) {
                                          return SearchTile(receiver: user);
                                        }
                                      },
                                    ),
                                  )
                                : const SizedBox()),
                  ],
                ),
              ),
            ),
    );
  }

  showLogoutAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget logoutButton = TextButton(
      child: const Text("Logout"),
      onPressed: () =>
          ref.read(authControllerProvider.notifier).logout(context),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Logout this user?"),
      actions: [
        cancelButton,
        logoutButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
