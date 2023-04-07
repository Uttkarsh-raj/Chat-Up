import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/controllers/auth_controller.dart';
import 'package:chatit/controllers/user_profile_controller.dart';
import 'package:chatit/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key, required this.receiver});
  final UserModel receiver;

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final TextEditingController messageController = TextEditingController();

  PopupMenuItem _buildPopupMenuItem(String title, IconData icon) {
    return PopupMenuItem(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          Text(title),
        ],
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: size.height * 0.1,
        backgroundColor: const Color.fromARGB(250, 49, 47, 47),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(6, 18, 6, 18),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CustomButton(
              height: size.height * 0.06,
              width: size.width * 0.2,
              child: const Icon(
                Icons.keyboard_arrow_left_outlined,
                size: 25,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.receiver.profilePic,
              ),
              radius: 27,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  widget.receiver.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  '@${widget.receiver.name}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 18, 6, 18),
            child: CustomButton(
              height: size.height * 0.06,
              width: size.width * 0.12,
              child: PopupMenuButton(
                itemBuilder: (ctx) => [
                  _buildPopupMenuItem('Search', Icons.search_outlined),
                  _buildPopupMenuItem('Report', Icons.report_outlined),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.69,
            ),
            const SizedBox(
              height: 3,
            ),
            CustomButton(
              height: size.height * 0.08,
              width: size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enableSuggestions: true,
                        keyboardType: TextInputType.text,
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: GestureDetector(
                            onTap: () {},
                            child: const Icon(
                              Icons.emoji_emotions_outlined,
                              size: 26,
                            ),
                          ),
                          iconColor: AppColors.grey,
                          hintText: 'Type a message',
                          hintStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (messageController.text.isNotEmpty) {
                                print(messageController.text);
                                // if (currentUser != null) {
                                print(messageController.text);
                                ref
                                    .read(
                                        userProfileControllerProvider.notifier)
                                    .addToMessages(
                                      user: widget.receiver,
                                      context: context,
                                      currentUser: currentUser!,
                                    );
                                // }
                              } else {
                                print('null');
                              }
                            },
                            child: const Icon(
                              Icons.send_outlined,
                            ),
                          ),
                          suffixIconColor: AppColors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
