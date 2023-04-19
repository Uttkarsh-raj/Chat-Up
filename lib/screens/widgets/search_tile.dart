import 'package:chatit/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/user_model.dart';
import '../pages/chat_page.dart';
import '../pages/profile_page.dart';

class SearchTile extends StatelessWidget {
  final UserModel receiver;
  // final UserModel sender;
  const SearchTile({
    super.key,
    required this.receiver,
    // required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(4, 3, 4, 0),
      shape: const Border(
        top: BorderSide(color: Color.fromRGBO(66, 66, 66, 1)),
        bottom: BorderSide(color: Color.fromRGBO(66, 66, 66, 1)),
      ),
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: ChatsPage(
              receiver: receiver,
            ),
            type: PageTransitionType.fade,
          ),
        );
      },
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: ProfilePage(receiver),
              type: PageTransitionType.fade,
            ),
          );
        },
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            receiver.profilePic,
          ),
          radius: 30,
        ),
      ),
      title: Text(
        receiver.name,
        style: TextStyle(
          color: AppColors.mainText,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 8),
        child: Text(
          '@${receiver.name}',
          style: TextStyle(
            color: AppColors.subText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
