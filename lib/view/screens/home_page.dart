import 'package:chatit/controllers/auth_controller.dart';
import 'package:chatit/controllers/explore_controller.dart';
import 'package:chatit/view/screens/profile_page.dart';
import 'package:chatit/view/widgets/custom_textfield.dart';
import 'package:chatit/view/widgets/search_tile.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

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
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          child: const ProfilePage(),
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage('${currentUser?.profilePic}'),
                      radius: 30,
                    ),
                  ),
                  const Text(
                    'Chat-Up',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.logout_outlined,
                    size: 30,
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
            isShowUsers
                ? ref.watch(searchUserProvider(searchController.text)).when(
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
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
