import 'package:chatit/constants/app_colors.dart';
import 'package:chatit/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../models/message_model.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.m, required this.u});
  final MessageModel m;
  final UserModel u;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 9, bottom: 0),
      child: Align(
        alignment:
            (u.uid == m.senderId) ? (Alignment.topLeft) : (Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (u.uid == m.senderId)
                ? (AppColors.sentMessage)
                : (AppColors.receivedMesage),
          ),
          padding: const EdgeInsets.all(15),
          child: Text(
            m.message,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.mainText,
            ),
          ),
        ),
      ),
    );
  }
}
