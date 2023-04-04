import 'package:chatit/controllers/explore_controller.dart';
import 'package:chatit/view/widgets/custom_textfield.dart';
import 'package:chatit/view/widgets/search_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/assets_constants.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CircleAvatar(
                    backgroundImage: Assets.logo,
                    radius: 30,
                  ),
                  Text(
                    'Chat-Up',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    Icons.menu,
                    size: 26,
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
            const SizedBox(height: 12),
            isShowUsers
                ? ref.watch(searchUserProvider(searchController.text)).when(
                      data: (users) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return SearchTile(userModel: user);
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
