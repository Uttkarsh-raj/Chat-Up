import 'package:chatit/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../models/message_model.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.m});
  final MessageModel m;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 9, bottom: 0),
      child: Align(
        alignment: (Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: (Colors.grey[800]),
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
